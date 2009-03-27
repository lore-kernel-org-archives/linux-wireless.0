Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZC0EU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:20:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pabs@debian.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] wireless-regdb: make distribution packaging easier
Date: Fri, 27 Mar 2009 00:20:56 -0400
Message-Id: <1238127656-1226-5-git-send-email-lrodriguez@atheros.com> (sfid-20090327_052120_459362_D712D6A6)
In-Reply-To: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
References: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the ideas suggested by Paul Wise (slighly modified).

This should make packaging wireless-regdb easier for
distributions, as well as developer wishing to help
enhace the regulatory database.

You will see a key.pub.pem --> linvile.pub.pem, the files
are the same, not sure why "-M" won't listen, maybe because
its binary. This allows you to now cp linvile.key.priv.pem to:

~/.wireless-regdb-linville.key.priv.pem

And then symlink it as:

~/.wireless-regdb-Fedora.key.priv.pem

when you want to use a Fedora release, just an idea.

Users should just do:
     sudo make install

Developers should do:
     make maintainer-clean
     make
This will create a private key for you and install it into
~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
     sudo make install

Distributions packagers should do only once:
     make install-distro-key
This will create a private key for the distribution package and install it into
~/.wireless-regdb-$(LSB_ID).key.priv.pem
To make new releaes just do:
     make maintainer-clean
     make
     sudo make install

The make install target now also puts both the upstream key to

/usr/lib/crda/pubkeys/

Distributions now build regulatory.bin but also trust your key,
and their pubkey will also be putinto the same pubkeys dir. Same
will happen for developers sending patches.

Cc: Paul Wise <pabs@debian.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Makefile                            |  106 +++++++++++++++++++++++++++++-----
 key.pub.pem => linville.key.pub.pem |    0
 regulatory.bin                      |  Bin 3080 -> 3088 bytes
 sha1sum.txt                         |    1 +
 4 files changed, 91 insertions(+), 16 deletions(-)
 rename key.pub.pem => linville.key.pub.pem (100%)
 create mode 100644 sha1sum.txt

diff --git a/Makefile b/Makefile
index 203152a..376311d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,38 +1,112 @@
 # Install prefix
-PREFIX = /usr
+PREFIX ?= /usr
 CRDA_PATH ?= $(PREFIX)/lib/crda
+CRDA_KEY_PATH ?= $(CRDA_PATH)/pubkeys
 
 MANDIR ?= $(PREFIX)/share/man/
 
+SHA1SUM ?= /usr/bin/sha1sum
+LSB_RELEASE ?= /usr/bin/lsb_release
+WHOAMI ?= /usr/bin/whoami
 
-.PHONY: all clean install maintainer-clean
+# Distro name: Ubuntu, Debian, Fedora, if not present you get
+# "custom-distro", if your distribution does not have the LSB stuff,
+# then set this variable when calling make if you don't want "custom-distro"
+LSB_ID ?= $(shell if [ -f $(LSB_RELEASE) ]; then \
+			$(LSB_RELEASE) -i -s; \
+		else \
+			echo custom-distro; \
+		fi)
 
-all: regulatory.bin key.pub.pem
+DISTRO_PRIVKEY ?= ~/.wireless-regdb-$(LSB_ID).key.priv.pem
+DISTRO_PUBKEY ?= ~/.wireless-regdb-$(LSB_ID).key.priv.pem
+
+REGDB_AUTHOR ?= $(shell if [ -f $(DISTRO_PRIVKEY) ]; then \
+			echo $(LSB_ID) ; \
+		elif [ -f $(WHOAMI) ]; then \
+			$(WHOAMI); \
+		else \
+			echo custom-user; \
+		fi)
+
+REGDB_PRIVKEY ?= ~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
+REGDB_PUBKEY ?= $(REGDB_AUTHOR).key.pub.pem
+
+REGDB_UPSTREAM_PUBKEY ?= linville.key.pub.pem
+
+REGDB_CHANGED = $(shell $(SHA1SUM) -c --status sha1sum.txt; \
+        if [ $$? -eq 0 ]; then \
+                echo ; \
+        else \
+                echo maintainer-clean $(REGDB_PUBKEY); \
+        fi)
+
+.PHONY: all clean mrproper install maintainer-clean install-distro-key
+
+all: $(REGDB_CHANGED) regulatory.bin
 
 clean:
-	rm -f *.pyc *.gz
+	@rm -f *.pyc *.gz
 
 maintainer-clean: clean
-	rm -f regulatory.bin key.pub.pem
+	@rm -f regulatory.bin
 
-ifneq ($(wildcard key.priv.pem),)
-regulatory.bin: db.txt key.priv.pem
-	./db2bin.py regulatory.bin db.txt key.priv.pem
+mrproper: clean maintainer-clean
+	@echo Removed public key, regulatory.bin and compresed man pages
+	@rm -f $(REGDB_PUBKEY) .custom
 
-key.pub.pem: key.priv.pem
-	openssl rsa -in key.priv.pem -out key.pub.pem -pubout -outform PEM
+regulatory.bin: db.txt $(REGDB_PRIVKEY) $(REGDB_PUBKEY)
+	@echo Generating $@ digitally signed by $(REGDB_AUTHOR)...
+	./db2bin.py regulatory.bin db.txt $(REGDB_PRIVKEY)
+
+$(REGDB_PUBKEY): $(REGDB_PRIVKEY)
+	@echo "Generating public key for $(REGDB_AUTHOR)..."
+	openssl rsa -in $(REGDB_PRIVKEY) -out $(REGDB_PUBKEY) -pubout -outform PEM
+	@echo $(REGDB_PUBKEY) > .custom
+
+
+$(REGDB_PRIVKEY):
+	@echo "Generating private key for $(REGDB_AUTHOR)..."
+	openssl genrsa -out $(REGDB_PRIVKEY) 2048
+
+ifneq ($(shell test -e $(DISTRO_PRIVKEY) && echo yes),yes)
+$(DISTRO_PRIVKEY):
+	@echo "Generating private key for $(LSB_ID) packager..."
+	openssl genrsa -out $(DISTRO_PRIVKEY) 2048
 endif
 
-key.priv.pem:
-	openssl genrsa -out key.priv.pem 2048
+install-distro-key: maintainer-clean $(DISTRO_PRIVKEY)
 
 %.gz: %
 	gzip < $< > $@
 
-# Distributions wishing to just use John's database
-# can just call make install.
+# Users should just do:
+#	sudo make install
+#
+# Developers should do:
+#	make maintainer-clean
+#	make
+#	sudo make install
+#
+# Distributions packagers should do only once:
+#	make install-distro-key
+# This will create a private key for you and install it into
+# ~/.wireless-regdb-$(LSB_ID).key.priv.pem
+# To make new releaes just do:
+#	make maintainer-clean
+#	make
+#	sudo make install
 install: regulatory.bin.5.gz
 	install -m 755 -d $(DESTDIR)/$(CRDA_PATH)
-	install -m 644 regulatory.bin $(DESTDIR)/$(CRDA_PATH)/regulatory.bin
-	mkdir -p $(DESTDIR)/$(MANDIR)/man5/
+	install -m 755 -d $(DESTDIR)/$(CRDA_KEY_PATH)
+	if [ -f .custom ]; then \
+		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
+	fi
+	@# In linville we trust
+	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
+	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
+	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
 	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
+
+uninstall:
+	rm -rf $(DESTDIR)/$(CRDA_PATH)/
diff --git a/key.pub.pem b/linville.key.pub.pem
similarity index 100%
rename from key.pub.pem
rename to linville.key.pub.pem
diff --git a/regulatory.bin b/regulatory.bin
index 49c6e4f3ce8f828c177b75a2c304e9b4a5548ba9..05a7147589daef2c700f3c9f01d5e7a1e21a789f 100644
GIT binary patch
literal 3088
zcmZ`&YiyHM7(QJu-$cMAV4MgMOouaEtYN|kP3&!K-P-c8c3U@Ugai{D3oc~gl3+3r
zkRSpY&`$wf3}VHqBU#8GQ<n(If(zM?fh1eFISAq+3jvv7UY_?o=agdfByZp6Jm-0D
z=X|X$4+Vq}lY}tZ;MWLYgQI2iNk49v^!a1bKiVn1kq_-`AzX*0Cq3=yoIJ&m*KzrO
z3ipvdQFO@^;-F8&el~^q6k>qMFHJ~3e%cgu)7!JW*;(+gJ~sV<9yqH9uG^9n_4%W$
z&tmY|x*B)-SX1;yTJ{6JsJlSSoahk(xboL_QMIs7h-V8JN8I4iCvjD8jW8eSZWfXI
zxC3YiM~^}eO?2X35q+_ZdG{wm6kWp|(7gLS56}B)GxPEF9#OZfLSoEbbHl?uQ2)u3
z7Z}I7<Q;Jy+*|Hlu^#!edR^=JWHx{8e3P;H+DJAwi!raTrSPVcVYEhIxj4kE<P!=H
z<!GAzg)uKL`d$!gYlSDQa@ufbjPao{Ce3CTox5RJw(0oMnDS{{nu8IS<uP9tuL52P
zLmgYc!iB(xfhnc{mR1;!aR~t|;=PO{rhB19yy{<U0M;79T0<E5d0xV~dYzwmHw??x
zjvwlW)<GEY)LRFPX4aTuHKtk`Q+|yp58<t_T&(rPYdv9=)7ApK5>|+QM&Z3M<gpFs
z;LE_OAD&I)UEm`y(sw<;q8oUs<QeOJ_JYgBT0^|bDG0k|tj$swjxp6D+=Cy5#RXuR
zix%Nro^sOag=r1pTs}eqEaK4{&*u;#kE~A!`<M_8(%Tg`i2Zc6F9t?lM?3aToMWE6
zBy1Dp6`+uVdFbpO7-~3H!A8N4hpqs&64ngc0ow;_gJocyuv3Uhz=jaB3o*!-r*mOe
z&Z9Zxv!}uJKu5in0O!LFV^6(dpLYjG-QY?UkN+R>T5sPAzW;&VPB}@Rf>B<o<pY;n
zOLGbELy)vUmnU_ci+Z6L(DsA)(fTIrw_@80j{5V#Zh+eWE(B`_ueBcVdS0DxIk*vM
zbS*1KuX`B=r}b{YjvPImQEUWd2<uwjoLc()zj9yBiBY*7T`H%K%Vy{L-+R<?rpkq0
z?1iv2+M)ZV_wji!JyM1IW#kRZ4;A*K{wR4@${%Cz^;eU3_W3bAc(1>Pyy5US@IDjp
z^S(L2d0gH=IrB|{3g$}#oY$2J$b3D4C44>_;JmJaKt1oh0hw<!$oZV9AjiABL5?@v
zK^Z?B<alRSP{tPr<1#*|@&q}LvmnI%INhNtc^;B+>5x1hEekSVT&DUilYI}CseFsW
zGH$V~<1G)!eYw<U$~DjT;!Ia?9m7$<eHvDUJRhv!`*L~1A&xi0s$N*mWrd}_G%WSQ
zVO2k@?z>XHhqsdZHzJkvs>0b)#opCg#c|HdRdvK0Ru#`@SP||QUd<7a{UswRZ$$MK
zsiioVH!9!JipqP*M5W$}%DRrIii;*m?@UMKeT$fUUvG?cE^kcsH5`+DY+b_r8>Oav
z*R(0;H%)opmMPzP*i`jQmCuxOrA<|Lsp_v<_G4Ac@6d`XKCbRH&Up=YT+JQlye@BC
z&RHDiz6~oOzfUV6zpKH7das16mrC$`I!kI){u+K4XR1cd-BlyMqf{-|H41ChyVuLT
z)ga@N4eDLKn6R;}Iq=~V=MRLp6@GozI=StgE4R;ow)Wb^X=m;<Ieph>4D6h@{@lol
z#@935_ighRo}2aFf+;^GjW4G*E^B(sb+)(a{n>B!Y?xbVUTK;9$JLwH@BQVd-}Bt6
z<7sE>q93<p><4;ZTCryR-P<RwUJO0czwg%2>g~VVKHlNEbML#7wtdUpJ9>H#y}j<3
zFEKB*?W^8*XJjU~?0I46@wt~?nc3l+@b`*yx9-oK)3&+1?$pFN?Xw0#O~FURt38d~
zzx9nj_HD0c!OqWLKC*k$(=8_gMQ8etjx|m?{=?m%5nmnue$l}A4|WeM`Q~o?^zr>u
d4jsKY&Dgl^qwO8PG(35_&O0`3?TvA<e*m%m<Lv+d

literal 3080
zcmZ`*Yiv|i5I(!xySEB~qBRh#NfWn9fXM!66-*QN)$ZMPce!-84`?-N0M~@*CSoYs
z#ul3>p_+>UEv8CC3Krsz5|+3zHP-Md_-bNRFg%*H1h54QV$!5-;y359UPwI2?0n}t
zGvCadbDOj#911YT9%fAMf`5%M2OKSZSojA!h0mWAeqL61Js+_v8FTjvPw}*;bMll&
zUghP_G0&l4R&vE;tlP)pV<s~nMGi3ebxFY|PMNH}xIf36*@AoH<Hi5Q1Lxv_>vuG;
z_4(60K8L~Q>MES|@tBg<KG6^OlEDJ@!~!p4z*Q6dta{BbV^0=v9QA-lpTt$aH^uqr
zV46i|a0iGX96N$|#Kaa@ELPUTdCz{vO0MD#Xx_cvd*?ln=6qtCm(@2K9GihraS!N$
z`fvF9JnttyAnu6k;NI+aReRmbb93>k)~be_e%;fi(0_F*muo7FTFlXeH!XzGnu6JJ
zh_ixEN<40h*>WGoynNC3f?P)%JYlKnz@2f74~=7rX@}9d2ZrS+#*f0Jr|@bUMqZA`
zd^wx~-Uve-$B4vBfO~-{rvTO`F&xLG1h9xN=SX0>7h1&2{#i4yiXp6G2t%LGOV}Q-
z^ojStupIsPp?+v}!-%KeGBBE1VaipQYAH<m3X=}u4wxOQc;Zz&VX5iZ3cL}v1pRcv
z%Us7aa5)T`j!7FH1(v<>ITaoNAB9m5gZJSg8!z>l1<sCD4DnKv$9P1pqYIue7ROYJ
z@DP3^X6J!vMp}gJJZaMU0j6RI+xaL3U=fer_<VVcImw0@bImfAw;E?I$z8;r@@c;e
zxEMBoy@oyJaW=qOaBP60dm$ciE-wr<@^JSWwAp;{ICpM@rD5;G_P}~zU&6AmlgLTJ
z#*x>B9OUJ+&PyG|LC@8PkP*aDZ>7M6uzu|EH%EKLyDadd*i&!dop-U%hnX^7@-EUG
z1eb!1Af9UZz}aglE(v}dA#DsnB97OfUVOYXb9LiP#cu)Efo&%^s^^1U2iFWP1fx4u
zv0m_MUZwXUxGBV_TD`#P%mbLQolQ#|g(P96TW-@O9Xcl+b*^Tbv~f~9Z%AtTc-h<x
z|9fXDuSsg5mTL*D59R1?>5Y6|ObRK}UqN2C{D{JS(jO!5PWj{98~z&d+C@J)1aJ6j
zxu5lK;65Ahlh;!LuH!ZWVa_)P49<H4T-Tiq2)*&ZT7Eti;JWUjz<Rzn0zz*p$n~^T
zkmtLNAkWu}f-*nI^R=O%$S(~hM1D}}1i6k@6yp78-cYqT4~e`?NSser1UX+?A^WZn
zeUDT~y~>Els}yyNF#Q*U`NJYU8&*8O7cFCmI<p4vQ@0FpK4OUbG9n?K-xQJcB4REp
zBI3Of5kDT0^&|4WtHgU4RlI*aRE57ByhmF#_wLSWk(XCpPrPnb^Z9fu%KL?vb3}Q6
zx*3(aQQ23tj`G|_OuVBN6ZevhiFhj}-fK1{^I{DYuVrHVzO}n?@xDe}#2InX*LYm?
z(Xy8JuX|1Lt{GFz-(-sW?lr|bkDIcdDfLV~mzFVQ-F33R8gUO+4ewvK5|U5Idrfd%
zy(l5)PKb9g5@OEM1n*n7lH&WclH$7>Ny_(1ih8Lezfa9qEA?ynyJ)Fe@tqCTiti{@
z$Ls0^b@JWUi@mi$<e3}fyKGAT8a@^F41V<3!LHL|J&RtyFgm=uZSjSl8t;75^JDCx
zvC7cTk3{nIxxd~x`HA-Fr4Rj|wQoOn$9Zewz|Oh9-(8cwW*)n7ZvU}~=IrvlGwp>7
z$39O*^WMBx;4Cex$ej3g=X3sJubi$w6K?!q>78?#i4*UvTk*o;$nif9+??KZ;^1!!
zJ-5#ctlawim0Qn*W-edf?s@8glPq1n;`GhF_NA>~?U~>G@uw4PdHv?t*?p^i$vk_c
z_3DkoFLyNW`n~v%OUa6DW&bRie`rPP+*@DlaNd5Y<>u|Ojs=&GvYCW&v?gdY?p~_3
k7k*!Vc=1_h<-E6#KOR`NeBa?s<@>aQ-)+8}ZpnoH1)hZD5&!@I

diff --git a/sha1sum.txt b/sha1sum.txt
new file mode 100644
index 0000000..ec63bd7
--- /dev/null
+++ b/sha1sum.txt
@@ -0,0 +1 @@
+46a39009a9944b92a0b48b258ea98570b23d0b95  db.txt
-- 
1.6.0.6

