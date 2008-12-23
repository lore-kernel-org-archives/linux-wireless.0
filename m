Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2125 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYLWFtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 00:49:52 -0500
Message-ID: <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net> (sfid-20081223_064958_213886_E71614CD)
Date: Tue, 23 Dec 2008 00:49:45 -0500
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	<43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
In-Reply-To: <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> I've been trying to avoid string.h on crda.c, granted it only
> increases the final crda binary by about 30 bytes, but do we really
> need it? In fact it'd be nice to further trim crda further to save
> even more space. Thoughts?

OK, maybe we don't need this patch if CDRA works correctly.  I'm  
having bad luck with it.

First of all, I cannot generate regulatory.bin that crda would accept.

[proski@dv wireless-regdb]$ make
./db2bin.py regulatory.bin db.txt key.priv.pem
openssl rsa -in key.priv.pem -out key.pub.pem -pubout -outform PEM
writing RSA key

[proski@dv crda]$ make
   GEN  keys-gcrypt.c
   CC   reglib.o
   CC   crda.o
   LD   crda
   CC   intersect.o
   CC   print-regdom.o
   LD   intersect
   CC   regdbdump.o
   LD   regdbdump
   CHK  /home/proski/src/wireless-regdb/regulatory.bin
Database signature verification failed.
make: *** [verify] Error 234

wireless-regdb and crda are current from git.  The system is Fedora  
10, x86_64 with a custom kernel.

Only regulatory.bin from wireless-regdb-master is OK.  It is indeed different.

[proski@dv wireless-regdb]$ cmp -b regulatory.bin /usr/lib/crda/regulatory.bin
regulatory.bin /usr/lib/crda/regulatory.bin differ: byte 2685, line 3  
is  36 ^^ 130 X

Once I install the working regulatory.bin, I can compile crda.  It  
appears that crda needs COUNTRY in the environment, but it's not  
documented anywhere and there is no sample file whre to set it.  I  
tried adding "export COUNTRY=US" to /etc/sysconfig/i18n, and it  
appears in the environment when logged in on the console.  However,  
crda doesn't apprear to see it:

[    0.720023] cfg80211: Calling CRDA to update world regulatory domain
[    0.720065] cfg80211: calling CRDA failed - unable to update world  
regulatory domain, using static definition

Not only did it try to set the world domain, it failed at that.   
However, running crda on the command line is successful:

COUNTRY=00 crda

 From the kernel log:

[ 3579.145902] cfg80211: World regulatory domain updated:
[ 3579.145905]  (start_freq - end_freq @ bandwidth),  
(max_antenna_gain, max_eirp)
[ 3579.145907]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)

But setting any specific country fails:

[root@ct crda]# COUNTRY=US crda
Failed to set regulatory domain: -22
[root@ct crda]# COUNTRY=DE crda
Failed to set regulatory domain: -22
[root@ct crda]# COUNTRY=RU crda
Failed to set regulatory domain: -22
[root@ct crda]# COUNTRY=QW crda
No country match in regulatory database.
[root@ct crda]#

-22 is -EINVAL, "invalid argument".

At this point I want that crda at least gives me errors in a readable  
form.  But maybe I want too little :-)

The kernel is current from wireless-testing.git.   
CONFIG_WIRELESS_OLD_REGULATORY is disabled.  CONFIG_CFG80211_REG_DEBUG  
is disabled (I guess I'll try enabling it now).  CONFIG_CFG80211 is  
enabled.  mac80211 is compiled into the kernel.  The only modules are  
wireless drivers (b43, hostap, rt61).

-- 
Regards,
Pavel Roskin
