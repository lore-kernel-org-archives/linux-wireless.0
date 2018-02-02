Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:43356 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeBBHvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 02:51:02 -0500
From: Pkshih <pkshih@realtek.com>
To: James Cameron <quozl@laptop.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rtl8821ae keep alive not set, connection lost
Date: Fri, 2 Feb 2018 07:50:26 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D13BE7A25E@RTITMBSV07.realtek.com.tw> (sfid-20180202_085106_873056_CCBC5C6F)
References: <20170912220916.GB32211@us.netrek.org>
 <a9a1ff03-d12f-7437-e7bc-5f01b195f753@lwfinger.net>
 <20180201062202.GH917@us.netrek.org>
In-Reply-To: <20180201062202.GH917@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf
> Of James Cameron
> Sent: Thursday, February 01, 2018 2:22 PM
> To: Larry Finger
> Cc: linux-wireless@vger.kernel.org; Pkshih
> Subject: Re: rtl8821ae keep alive not set, connection lost
> 
> On Wed, Jan 31, 2018 at 11:06:12AM -0600, Larry Finger wrote:
> > On 09/12/2017 05:09 PM, James Cameron wrote:
> > >Summary: 40b368af4b75 ("rtlwifi: Fix alignment issues") breaks
> > >rtl8821ae keep alive, causing "Connection to AP lost" and deauth,
> > >but why?
> > >
> > >Wireless connection is lost after a few seconds or minutes, on
> > >every OLPC NL3 laptop with rtl8821ae, with any stable kernel after
> > >4.10.1, and any kernel with 40b368af4b75.
> > >
> > >dmesg contains
> > >
> > >   wlp2s0: Connection to AP 2c:b0:5d:a6:86:eb lost
> > >
> > >iw event shows
> > >
> > >   wlp2s0: del station 2c:b0:5d:a6:86:eb
> > >   wlp2s0 (phy #0): deauth 74:c6:3b:09:b5:0d -> 2c:b0:5d:a6:86:eb reason 4: Disassociated due to
> inactivity
> > >   wlp2s0 (phy #0): disconnected (local request)
> > >
> > >Workaround is to bounce the link, then reconnect;
> > >
> > >   ip link set wlp2s0 down
> > >   ip link set wlp2s0 up
> > >   iw dev wlp2s0 connect qz
> > >
> > >A nearby monitor host captures a deauthentication packet sent by
> > >the device.
> > >
> > >Bisection showed cause is 40b368af4b75 ("rtlwifi: Fix alignment
> > >issues") which changes the width of DBI register read.
> > >
> > >On the face of it, 40b368af4b75 looks correct, especially compared
> > >against same function in rtl8723be.
> > >
> > >I've no idea why reverting fixes the problem.  I'm hoping someone
> > >here might speculate and suggest ways to test.
> > >
> > >As keep alive is set through this path, my guess is that keep alive
> > >is not being set in the device.  Or perhaps reading 16-bits
> > >perturbs another register.  Is there a way to test?
> > >
> > >http://dev.laptop.org/~quozl/z/1drtGD.txt dmesg of 4.13
> > >
> > >http://dev.laptop.org/~quozl/z/1drt7c.txt dmesg with 4.13 and
> > >revert of 40b368af4b75
> >
> > James,
> >
> > I'm afraid we are needing to revisit this problem again. Changing
> > that 8-bit read to a 16-bit version causes an unaligned memory
> > reference in AARCH64, thus we will need to re-revert. To prevent
> > problems on systems such as yours, PK plans to turn off ASPM
> > capability and backdoor in certain platforms that will be listed in
> > a quirks table. Please report the output of 'dmidecode -t system'
> > for you affected system(s).
> 
> Thanks for letting me know.
> 
> We made three production runs, and I'm waiting to get a hold of the
> dmidecode for two of them.  This may take some weeks; we have to find
> stock and ship it, or we have to ask our contract manufacturer (CM) if
> they have kept data or units.
> 
> I've dmidecode for one production run.
> 
> http://dev.laptop.org/~quozl/z/1eh7JF.txt (my unit nl3-e)
> 
> I've dmidecode for prototypes, but they have clearly been programmed
> badly.  We did not ask our CM for Windows compatibility, so they may
> have had no step to verify the data.  We also went through several
> iterations to get serial numbers assigned, so the data I have does not
> have good provenance.
> 
> http://dev.laptop.org/~quozl/z/1eh7EE.txt (my unit nl3-c)
> http://dev.laptop.org/~quozl/z/1eh7EV.txt (my unit nl3-d)
> http://dev.laptop.org/~quozl/z/1eh7He.txt (my unit nl3-a)
> http://dev.laptop.org/~quozl/z/1eh8DR.txt (my unit nl3-b)
> 
> > We hope you will be able to test any proposed patches.
> 
> Yes, can do.
> 
> I've just tested v4.15.
> 
> However, I'm concerned about your plan to use quirks;
> 
> 1.  turning off ASPM may decrease run time on battery, which if it is
> significant, across several thousand laptops will yield generator fuel
> or solar budget failure; can the power impact be quantified?
> 
> 2.  why not keep ASPM enabled, and use 8-bit when quirked, or on
> x86_64, or when not AARCH64?
> 
> 3.  why not find the underlying problem; PK is in the same company as
> the device firmware engineers, so it should be possible for them to
> find out why 16-bit access causes the device firmware to hang?  We
> drew a blank trying to reach firmware engineers through our CM and
> module maker; perhaps we were not large or noisy enough.
> 
> 4.  it's not just me; there are others who have reported similar
> problems, so won't re-reverting affect them?  They haven't engaged in
> the process as thoroughly, and may not be in the quirks table.  You
> also reproduced the problem with different hardware.
> 

Hi James, 

In my experiment, unaligned-word-access may get wrong values that 
are different from the value by byte-access. Actually, it can simply 
verified by using 'lspci' to check PCI configuration space.

DBI read 0x70f:
_rtl8821ae_dbi_read:1127 r8 0x34f = 0x0017
_rtl8821ae_dbi_read:1131 r8 0x350 = 0x000c
_rtl8821ae_dbi_read:1136 r16 0x350 = 0xffff

DBI read 0x719:
_rtl8821ae_dbi_read:1127 r8 0x34d = 0x0000
_rtl8821ae_dbi_read:1131 r8 0x34e = 0x0002
_rtl8821ae_dbi_read:1136 r16 0x34e = 0x0200


According to the wrong and original value of 0x70f is 0xff, I think
larger L1 latency 0x70f[5:3] may be helpful. Please help to try
below patch. If it works, quirk table won't be necessary.

PK


diff --git a/rtl8821ae/hw.c b/rtl8821ae/hw.c
index 7d43ba002..e53af06ed 100644
--- a/rtl8821ae/hw.c
+++ b/rtl8821ae/hw.c
@@ -1123,7 +1123,8 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
 	}
 	if (0 == tmp) {
 		read_addr = REG_DBI_RDATA + addr % 4;
-		ret = rtl_read_word(rtlpriv, read_addr);
+
+		ret = rtl_read_byte(rtlpriv, read_addr);
 	}
 	return ret;
 }
@@ -1165,7 +1166,7 @@ static void _rtl8821ae_enable_aspm_back_door(struct ieee80211_hw *hw)
 	}
 
 	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x70f);
-	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7));
+	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7) | 0x38);
 
 	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x719);
 	_rtl8821ae_dbi_write(rtlpriv, 0x719, tmp | BIT(3) | BIT(4));
