Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65194 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GQQjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 12:39:47 -0400
Received: by wgbfm10 with SMTP id fm10so3430025wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 09:39:45 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] linux-firmware: add zd1211rw firmware
Date: Tue, 17 Jul 2012 18:39:28 +0200
Message-Id: <1342543168-6666-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120717_184001_225750_BAEBA8B0)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

firmware for zd1211rw, ZyDAS/Atheros ZD1211/ZD1211B/AR5007UG wireless driver.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: linux-wireless@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
README

This distribution contains the firmware files for the
ZD1211 chip, which is used in WLAN USB sticks. Copy the zd1211_* files to
/lib/firmware/zd1211, where they can be loaded by the rewritten
zd1211 driver.

The files are generated from C header files distributed in the
original ZyDAS ZD1211 driver under the GNU Public License.

The full source of the original ZYDAS driver is available from
http://zd1211.wiki.sourceforge.net/VendorDriver

The GPL-licensed header files used to produce the firmware blobs are also
present in this distribution. See the COPYING file for the full license terms.

HISTORY

VERSION 1.4 (2007-10-04)
Sync to vendor driver v2.21.0.0
According to Atheros, this firmware fixes a USB disconnect issue which most
commonly appeared when running "lsusb" or "cat /proc/usb/devices" while using
the device.

VERSION 1.3 (2006-12-30)
Sync to vendor driver v2.16.0.0
Large packet support is now disabled. The zd1211 firmware is now the same as
v1.1 but the zd1211b firmware is new: It is the same which is shipped in the
2.10.0.0 release which supposedly fixes a "reboot issue"

VERSION 1.2 (2006-07-22)
Sync to vendor driver v2.13.0.0
Release notes mention that this firmware includes largepacket support

VERSION 1.1 (2006-04-30)
Added ZD1211B firmware files

VERSION 1.0 (2006-04-16)
This firmware has been generated from fersion 2_5_0_0 of the Zydas
driver, 2006-04-16.


 WHENCE              |   20 ++++++++++++++++++++
 zd1211/zd1211_ub    |  Bin 0 -> 4018 bytes
 zd1211/zd1211_uph   |  Bin 0 -> 5120 bytes
 zd1211/zd1211_uphm  |  Bin 0 -> 5120 bytes
 zd1211/zd1211_uphr  |  Bin 0 -> 5120 bytes
 zd1211/zd1211_ur    |  Bin 0 -> 3584 bytes
 zd1211/zd1211b_ub   |  Bin 0 -> 4018 bytes
 zd1211/zd1211b_uph  |  Bin 0 -> 5120 bytes
 zd1211/zd1211b_uphm |  Bin 0 -> 5120 bytes
 zd1211/zd1211b_uphr |  Bin 0 -> 5120 bytes
 zd1211/zd1211b_ur   |  Bin 0 -> 3584 bytes
 11 files changed, 20 insertions(+)
 create mode 100644 zd1211/zd1211_ub
 create mode 100644 zd1211/zd1211_uph
 create mode 100644 zd1211/zd1211_uphm
 create mode 100644 zd1211/zd1211_uphr
 create mode 100644 zd1211/zd1211_ur
 create mode 100644 zd1211/zd1211b_ub
 create mode 100644 zd1211/zd1211b_uph
 create mode 100644 zd1211/zd1211b_uphm
 create mode 100644 zd1211/zd1211b_uphr
 create mode 100644 zd1211/zd1211b_ur

diff --git a/WHENCE b/WHENCE
index f12b77a..68f45a2 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1980,3 +1980,23 @@ Source: isci/Makefile
 Licence: GPLv2
 
 --------------------------------------------------------------------------
+
+Driver: zd1211rw -- ZyDAS/Atheros ZD1211/ZD1211B/AR5007UG wireless driver
+
+File: zd1211/zd1211b_ub
+File: zd1211/zd1211b_uph
+File: zd1211/zd1211b_uphm
+File: zd1211/zd1211b_uphr
+File: zd1211/zd1211b_ur
+File: zd1211/zd1211_ub
+File: zd1211/zd1211_uph
+File: zd1211/zd1211_uphm
+File: zd1211/zd1211_uphr
+File: zd1211/zd1211_ur
+Version: 1.4 (2007-10-04) - vendor driver v2.21.0.0
+
+Licence: GPLv2, found in hex form in the vendor driver
+
+Downloaded from http://sourceforge.net/projects/zd1211/files/
+
+--------------------------------------------------------------------------
diff --git a/zd1211/zd1211_ub b/zd1211/zd1211_ub
new file mode 100644
index 0000000000000000000000000000000000000000..1c30fb407dec2e94457e6806819860dffcd85831
GIT binary patch
literal 4018
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

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211_uph b/zd1211/zd1211_uph
new file mode 100644
index 0000000000000000000000000000000000000000..638c42a8de999490578bbfdbf378d025f3a36e9c
GIT binary patch
literal 5120
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
H|MU4DQO=kq

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211_uphm b/zd1211/zd1211_uphm
new file mode 100644
index 0000000000000000000000000000000000000000..6101988468dd868e1420b0c7132868bfc5d0505d
GIT binary patch
literal 5120
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
H|84Le6o|fL

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211_uphr b/zd1211/zd1211_uphr
new file mode 100644
index 0000000000000000000000000000000000000000..6734da36cddb49b1b97ba8a96d42b3112b74621e
GIT binary patch
literal 5120
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
b@&fyOxAcB(24<0k4{FxIYdK8%|M&afULVB{

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211_ur b/zd1211/zd1211_ur
new file mode 100644
index 0000000000000000000000000000000000000000..0fa192818e3ddd5d4730e2dc0dd39b5746fe49c5
GIT binary patch
literal 3584
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
H&-H%*4A{vg

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211b_ub b/zd1211/zd1211b_ub
new file mode 100644
index 0000000000000000000000000000000000000000..0454e96f6e7298ae23fbec9cd29a17f0358eeb56
GIT binary patch
literal 4018
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

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211b_uph b/zd1211/zd1211b_uph
new file mode 100644
index 0000000000000000000000000000000000000000..638c42a8de999490578bbfdbf378d025f3a36e9c
GIT binary patch
literal 5120
zcmcIoeQX<N8GrB2PIBiquAMRFWNb+X)zo${5E9xX#+~gZVIO7MCaR&5^<$wM^mAL=
zt?fFKZfyjDWp}=_6UH2xRS3jBs8>*jyVg#PvO&>ucHDHDkS3@YaC6RIan-Ih&-0!y
zb~VO-q^j?|_kG^yeLjEB^IqEvwU2n^hWvEclON7bYtzxSqiaX+9(DYDIyybZ<;&qr
zR$4CJx$3Q9S^B&fy#FoHRPs_jI`(#zB{v#`9KCQ43Bhxs>Ld2w`0V&dbSyeHJ}a70
z6UR7uc+MWZw=h?mx97fHu}3p>)!GxT;_UEyZ7zl^<~YJT8IlV7*`&;AU1ygc?3`I~
zke?tSUuNY&k{1R~?O`L6G9SNEOX<VW5!mVPw)Q%SGn~#^`<X0o&?xojX<0gaT2Du>
zKezlK1HUT{cAZ6D77stMxJZ<XXr9k|lrvSy&knd_uja*qDEl&Js%cq*Cpmy`<bXS-
zUU0`o^L|P-nzv|pB~kTdHXEXOsK{?biHj$YN~)iLQX-{S^<|d8e-<dXq2^tpSt@xH
zhhg#k8|CW&e(Q>sjL5;G1T{WhyX?yZHPQS@bt`amJ}a81^LK3!)Gy|zv#!XB{B%xG
z2_1ilj=xIBx6$z(bR3}LemcH~j#uZCSz(X_(Z0dMDLqi&73Leh%&F(<XMT)lHY7oB
zahk+(qo>1uN79iBPi7mdsOeUtBeKotI?IMU%HxJFvrltH#!1)N-G(sO?zj9{JL#Et
z!bs`D;J*WOX5tjVw|`o1@skUF?xP;MW|RvpijyUxpIz;a?KM5henVn?nf-=G`BT-J
zeRfV5yz-32jW|*|_zUQ^8mtcM;MaHO(3@L9qWy+fWka1a+d$HN5O0q+Nk&9p<_QBl
zDW-Hb+&QyPgLB&~4zJHGiq~4*u{Y*CN=pd*(aLjV+?Uy5h*4K$ui;QR=QZ38qZi^h
zrAux8e)c7I><>V_!$`_${h_12%pSuX%gl8|9y8K8ue!$&gQ(GVQ;4?_OOL{w5O0Ny
z7&cO2Cd+dn*o*tp(M88ejrmo2)*ZV%Cpc?0fg6D}M(><~Rhj2%wX}|BrNhZAKKWJ`
z;c}DFmf3yk9`$aJ>Oti}g*n1R7ghEuJkO98$f+7}=xbr#5oV5X+9ch1H|x}sutsXQ
zlbvuzPwQTFhq200w=a`|_dP~K>QyGL-|1i>^MHS8uOhMT*!Rppko~DUwh273!|<~x
zwI$n~tXEy9C9}BeE{kjYM)11z?ol>q637JHASTnG|6_)rE@C@p*bw^lYEO&iZF9D_
ztsMT5iE|!hn-M%}SyeUr0R=E7HyhGYK~>G+?C|?9jP*6;DP-YLf1Um}aK`1Q>(P1z
zya_TyAle*5fumlP8)D-Y-wb$;)cOx&R*NPndz6S_$&dk^TZcRW&S2ZY=kNx3KS3Bu
z2~ig@8hO(gd6e$NlrEav3pRoT>qys1S|RU}GON4bL_R=%hEZKJUEJGi*|4rn=Tgxm
z#Kx8atc~JYcfrMxP3t2r?z0zw0#;Mub6HLodvO)$AYxpR{bVXPrLT!j0hZsN4-i~|
z6HMSTf^@e67nY<U8w8Fa5XTS;tegyUN;2!}BdW!V)h1=BZo4f7j}kS&KJ*j`>>i~V
z$7Drwf6=w+^3#AG@}kjh?)q~rL%7Zk`Qg_&wCK^$GuNLZucMtNbtWvt9mKNp4+{R5
z(fh%=zbyQBLRPJ-pZat`G{0U=!=5GeJqKathn2MEii`D`=V2yMMjAk6iX~>DBhr&#
za;`XApZNvQY`D~X_OD@P^CbrO*t_0=nb$93OuSPCzZ!f%B&hAFf(V#_a|HE=%+3Ji
zx*|Stzn$YayN{k>%lbad9J=IDmelLOKMFyJ5m&+;`>0^W(?<ng#+5*XT>=>{#6xv?
zZ!dO4Zl)U8TCzpa?5?5)woadcnbUdEeEyPX28tqZCI(7>hEmx!{xVR#bP2F8$V4W?
z{Vyl8gjS=gYgc2Rt<CMQ@6}7qRm85ZSi2BQu__9K|Dx!QRb~O{Cq#<-%~hb03wAvf
z20y&2O4O-om9V+;@k<LegPy8jrm>+WZVKUX24m2wQ&Tz*Xn@(ae6Cqy(HtvV-g~8J
zBMnOJj=c$*CW^2IzJ9a#Y5P4&;e;=v0$M2bEXdN{0Ie#twvuE{aFX%Pne9NKLOo(a
z_9+saBFdJ`R&UY~0Uk78A1Ha%?S{a?eyA=UWxIi0Pd}|S__mr&hSRyU>}lO@xHvaS
zMtfWKC{HPC)$ag;PwEaetw}BEoWB>V(&eJX!ATHPEPjCa$8IDRVlOXQm1#u@G20zm
zQ3`}{2Xt6aA+{Uegk8Rj0x}e9oike?1Kw>#z7IezGhM~nJPld!Zj}cQ`!eu^-iT3C
zkR4$I<4=J)_$JV90c21OHh@*)a0!ue=O;LX{wD_xDlri)e;tCoHu4-QiRNEQ?pUHE
z$y2(Zf~Nt0(9?Aq$j-5nA7qJwEQyls13&e2qU2o#$PF}ad_o@5h8m&PD8KIupnbjb
zvoV`?eQ>%6C;#^t^C*9=_bq>glM|29N^^j)=!r1Igd^lt6{B;;8KRbpOoE(XIk2As
ztHl$|aox@NGA+<kTD8Sm30R#i;G<V{3^kBoS6P@~!JdvG8?A3HOIkW744$axScqn1
zJ>ww9+_AOgZ)skY0WLQFeWl!|c@(XVacj!KAo_ky*{hNvh?m!x>{Je|E}BnP{e;mb
z!^|-&p4OCE`Cf>e!xYI51HOH?EDR3Nv-`pFh%Oq~)vlsD${i6h1l{D&LOq7sfLVg|
z*d2SSoCeEi(EnIj`5bVwaK=J}KvR9UZyI<@NXgt%*zu}67A<pJ!<tarLr~G{@$|d0
z@O$X~X#O3C+Rj1Oi8lzZ+8Sb3Vay&cOEN@q`Rc6ogWa#jIFGU$a%7xViNBZmjcozf
zrrJZ05zw>mF?7)3VnWxFIUV%6nCP6@4Z3j^pxM@S_Cf;Z_+z9dtg@<pwai1+_hpdk
z+6v6ldf!@sest4%g@<~NYZBay+_CE_d|-)+k?gHBBLBLIEAk|C=|DweWH-%@QMk)o
zNT94~jpH!GFD8V+`xd;j(63YMm53ehR<yN1FDeY0-$%~SxkWRxY)*jQ0dOx0{lP2)
z`k`j&=ryBH8mZZ4-(aSQ=GQ7xQ+DpCSa+hWmFC<;&qtwSZ>|{&wr;vPJWMmdqr8^r
zJBod;XX0d{N4KM1t@Owe+oL;GQR~k2Xd4xG>`0{}@^M1XbwsYfZ@1=e>4smXkG;Vi
zd$E$1H`0o}e;)mwsH~@N_s?&j&*_RgHayP<Zf4NZA5@U$oysG0?L&Kw#kH<^q+~z~
zj0o_|fIAkL_b6V~wgA3E)&t7yq8Yyv5VJeyQFZ}+xrUsF=NGrKWHEH`4ka1(w+Y8;
z1o|=A--4Rnq%%j58oTRVkV`uaeaM&D323s*=$8F#x8CQsxCpC&A7pNYN{Ey^aC!==
z2J>9!%ua&|qIBZ?HozUYZx&pUYU@-EWdm8mh^Npo7Pdh2I-kYN-ECn17??+#!u#H*
z`-tkmImndGP|u$?d!WB8*VZdNI%*53(TCLlG<CL+ZrRE8u~RytWWX_{FNKrOn|_!N
zfHq6RJ%04jBh<1i$i-+=Ifv{Fj{x0|=Y!<oIto~~$;F&N1kDxYoh*EHNM{33%NU*2
zACj3cd()IY0-f-E)d0jTJL*wF8h`8=sBs|;x~>DYnkT+eL2Q9<6AFW<13o=JFTttJ
z`^0|d9qejA4$$EYcz31Jf7l(HrXxOHrMo#9=Yw!}XmErs8|p2a1+)aqABQ-|ZU&Tq
zv)NxJbBz1|?L8{<C`ng*r6LT5tlBYwxZQl40WZ<MtKQ83w<T5VUfi)8sv_8@QJ3uO
z!XBr&4{G#XR+rX{tC)qi05;58Rii2Iu=d#)j2sa)p~qRk?*Pm-@RpMuVJCdkSX;$8
zF5(+l*UPnwVNo6#3-&tOA5_NF;Ij6CzI^+MlQn*lgxG=hS41KyewAsLUY3^Kvl_n#
z;i<q&TRd<t*j$wPe6ZI6yMxOd1HE}kk(LEkH%=AJ-(G3FHAWo7?KpPtBRKat(n;WJ
z2f2>;VAMsfB|XGTc+vsy_^*fD0{^W)rv5xsOjQYak^X*AJX!rCyqzqis<#Gg3j1r?
H|MU4DQO=kq

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211b_uphm b/zd1211/zd1211b_uphm
new file mode 100644
index 0000000000000000000000000000000000000000..9afd7aac13a4c5a62341f0c56c75333fcbb4323f
GIT binary patch
literal 5120
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

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211b_uphr b/zd1211/zd1211b_uphr
new file mode 100644
index 0000000000000000000000000000000000000000..226cdbd19b374c8304ca1a9815032543f9de86d5
GIT binary patch
literal 5120
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
N_Q9KJniT(E{Rh;mUi$z5

literal 0
HcmV?d00001

diff --git a/zd1211/zd1211b_ur b/zd1211/zd1211b_ur
new file mode 100644
index 0000000000000000000000000000000000000000..0fa192818e3ddd5d4730e2dc0dd39b5746fe49c5
GIT binary patch
literal 3584
zcmc&%eQX<N8NWLxY3|O+`J8l<lhCCb6^M0$@iB?<b!R)FDa~4_0F_Qt+BH-aDIFgg
zYC&tY?jr)NA3i&_Bhix<p-HQ>KN2Ro>00KrVITogY-ep5LY1b8NxZYqXHP^z)cl_J
z?Ab|!#DBzk?e~4&_kEt{_k6zTK3{)dwmwo?PU@xU;_}RL=F#k<*<IO=UoK~sX9J~L
zvQRWXVeA~aGMz9#YQ*<mG2Gi#vy_<?g?pGF%&(3M>;E#dcYef5XJxD+WAs$+#`o6B
z{guyEzEauZ-RnKzP2uxx@1Q3LA1hD)rCSw+a7tiiTzX8iFO_slWJa_(mp+{Do*BIU
zDQ95iloQN8Ck)*@=Zq$UM~=nBbg`&zs@IKC>C2k^y;2nC4md_4QkZa*$=}AL?6riv
zVArqZm6Rt8tUTy^BQtdKX-Br679xd&V<ZPwqK-N@j8)80)3=4e>z{V^;>;PGISuLs
zM@bpD8FwbYdj#_9kpCGcj@4NwQm`EZrw>E7??U2hF)4kOOT3z&&YYWFk8oSLg^=b=
zgxkt3gi7i;$RmX6;bXBvQ4RoKl<>V>GC00q)_@K^!bL7^v4syOTKI-;MuAazX&AU-
zKyn+Lfe)z9V09X+3(nBZxI@U)bRDOF47&|v;B^@L{~ei<k{KcXK~#D~v%g=K&S>@*
z%1`i>S=Q{C@(=lZg3pyeK*)h-FH-`dkb|5ari|3zr(65WDrg5RJuuE9g>jq^{uU|p
zuqdpnGvdT=!?TUsnDsEj{bZH)Oss-V6dc{lk%G!2AjHC{ac0Cxvt(I{NxhnVwydUw
zkTNNR^O?d8Q_^GOOxmK^&zC7?#<?8LPObXBGlwZYmB||oul~Efn3t_Oq9P2>_hIy7
z+=X$s6FefsJFHw%d9_?$Dw@zla@51+SRe%t%^AYg{L+m2t6||<(G=RbliXe))-ePO
z5ktbzFhUqZz?k9MbvuO8y}b6mZiSi2ZM@SZsbQvDf+H^&0%8Wpx4N<=NRdK-$<~9b
z&>H>{vw@Us-NnStfYlMmB^L8$S8P<epxIrnZhe0BxOLo$6b5kP9%#^y--lqCI5-)=
z{=ad$e;ucX8k~sZW^h!xU^&*84m#?>DM3kfv3y=#m=MUqT}<wj1a%>R)lx#YdSPLi
z^=E@lU%J=XpWdGyl$CXBb=^7$J8Yu*0UNyF$}vNrs$xN_L1x~oq<-N}7pMPveiqT=
z8tw-!PGWz?jl#wu*0eGCpJI%>6k@H6)-9by`Hfd_`@|jlbY5rVFV$(?imzL*jV!to
zZj;g4{TGkBCt&-|XIk7^`~T$oN7wD^mdw5urQAX_4t%zhyI{DxDw@5sVz>tzzfbaC
z-O?JBb_{!^4QP@__tu_!Y6IE}8_@o|0j<VqMxupAx4PNxc{wn|a<D^?XK=4W-ay3T
zd#&{qig_UWQH89wg<Cp=82vHUEuM%nCZ-l=%u$MhvlYtppI4%Ml?BRM6%*Bn?!8k%
zO^8#sFkf8EH)*DnOHeMvc@$l$P=>r*8R4sU{QFVjc?<R(=X(1&+T^$z+mk_cydgjS
zLCnmEm>EgQ3TD5~Is#ZhcF^%9pawW*$9Li+;c6wAeG2s*^^BvZ7$Oaggl04N0MW@K
z?;jN(c?+)&ymG8AkY(!F6?w%VZ3M5~F1ppvP`RaCQMWcTH7#$-y``iSUdahBb(~Rd
z-ziTH7>FF*>I0X39(9{KRhGvzd&(m|ntiB2-NWrN=8^O-d4A@_;O8lCg756+bJ=<r
zRj3E|_IgU{*edk^nycv(tAp2jkhQel?@@iCb2%=NYNTc#gT&38N}g%b$Syy_PA}?x
zkfF}QhR3~um0sQ*%(i$yWyI~KT{ns<`Bk9fZ;?505STJqZ`A&i$T7|S1LU+<*GnE=
zE|515`)c+d`5nU@D{1x{v;#{tX|I<)<TZB+b<J?!tlp`Ch{}D6?E8pjdtU2h^e*J8
z<afw=kIV8vp+3<>Gq4h3lGPpy?Yy>E`_d}ID+zwvUgdEDq~yO*Sdx4yj`(|n*F}cj
zwXTcYSM^bC!|&^*mhPJU0BWBvHO9MTIMs{lZU`qi`Y%=`Yv4Y3B6A=m73JTE!qQu@
zc@dWURyCaJfyU&=pp)l$Mp;1dV0KG8D6e)@my&+}J_Ma97U--v101l=RMpQ9@;odC
zWIw6$s*5fdVzEY-jdHE%487w{@~D2kDyAaaNGp1Wi22yBmx`Kwk;^~~Ik_U~Mtx_W
zwa-EZON)8k>TGnAm-#spJ(V;SlLswvjI=#pU216d8uzSwxuw~)HqD|9&8WASGp$!@
z8L!l6huO80cj7-)Y0qxFVAt-wU2XYUwz~U~>CY&Ww}0xtJ?ppd8k~IN1g&<Unzf&$
zmp~kRPaW~kQdEBvR^5KifBPEG%GNI4N94zaej~YDL_J{?bpthedxnuyZ<b~2tEET*
zeH4^V*lF1DBX)c3_lWC<Yo>rGtNC($`*$Xm^5(pMYPuFqZFR(=vLFdQWlzm;v#yv_
z7CIV~eW1*73i>b4hC`tI9k0lvH9FVbpdJNvfu9RCC{KcN1zkSW=+7r>ab)J{nqM=Y
zt?}0(kB}wsY3AC+nr?mE5%bZ8j#+T|-5QNv1Z9O&nzAo~@~+$NO~ZY!%`=35{r^k<
H&-H%*4A{vg

literal 0
HcmV?d00001

-- 
1.7.10.4

