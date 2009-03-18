Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc2-s15.col0.hotmail.com ([65.55.34.89]:35248 "EHLO
	col0-omc2-s15.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZCRTGz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 15:06:55 -0400
Message-ID: <COL113-W1821F12C4E3E4E83852BBFCB990@phx.gbl> (sfid-20090318_200658_863355_B8F4BCD8)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: RTL8180 Bit Rate Regression in 2.6.29
Date: Wed, 18 Mar 2009 19:06:54 +0000
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> It would be immensely helpful if you, or someone else with this hardw=
are and the
> problem, could use git to download the mainline tree and find the bad=
 commit
> using bisection. In a review of the commit log, I found only one chan=
ge in the
> rtl8180 code in the 2.6.28 to 2.6.29-rcX range, and without it the rt=
l8180 would
> not work at all. As a result, I cannot suggest a trial patch.

Ok, I've finished bisecting between a 'good' kernel (2.6.28) and a 'bad=
' one (2.6.29-rc1) and have identified the 'first bad' commit.  It seem=
s that the problem is introduced (perhaps not unsurprisingly) as a resu=
lt of e6a9854b05c1a6af1308fe2b8c68f35abf28a3ee - mac80211/drivers: rewr=
ite the rate control API.  This is the first kernel build in the 2.6.29=
 development series which shows the Bit Rate failing to succeed at anyt=
hing other than 1 Mb/s.  The previous 'good' kernel - faf3994a9f65fd95a=
68bbcc03c318a427cd1e7d3 - succeeds as expected in this respect.  Presum=
ably something is broken/incomplete in the changes introduced to driver=
s/net/wireless/rtl8180_dev.c in e6a9854b05c1a6af1308fe2b8c68f35abf28a3e=
e, but it might be more subtle than that, I don't know.

Again, I can certainly test any patches.

Hardware is 1799:700f (=3D RTL8185vD + rtl8225z2)

Thanks again,

Adrian

git bisect log

# bad: [c59765042f53a79a7a65585042ff463b69cb248c] Linux 2.6.29-rc1
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git bisect start 'v2.6.29-rc1' 'v2.6.28' '--' 'net/wireless/mac80211' '=
drivers/net/wireless'
# bad: [54ac218ae676931813169e0ca074aca2e4adee38] rtl8187: fix 8187B th=
roughput regression
git bisect bad 54ac218ae676931813169e0ca074aca2e4adee38
# bad: [154662a6356ec3ccfea0a22218cf149220ea6373] ath9k: Remove unneces=
sary TSF reset
git bisect bad 154662a6356ec3ccfea0a22218cf149220ea6373
# bad: [9387b7caf3049168fc97a8a9111af8fe2143af18] wireless: use individ=
ual buffers for printing ssid values
git bisect bad 9387b7caf3049168fc97a8a9111af8fe2143af18
# good: [faf3994a9f65fd95a68bbcc03c318a427cd1e7d3] airo: Kill directly =
reference of netdev->priv
git bisect good faf3994a9f65fd95a68bbcc03c318a427cd1e7d3
# bad: [9de5776ff33a006b864341a6ec8d31f1a3c628cf] p54: p54: refactor p5=
4_rx_frame_sent
git bisect bad 9de5776ff33a006b864341a6ec8d31f1a3c628cf
# bad: [3257e5d4eb418e4656542207720aef5f0f547701] iwlwifi: remove host =
commands structures from iwl_cmd
git bisect bad 3257e5d4eb418e4656542207720aef5f0f547701
# bad: [5c7f9b7363bfd10e40cf1a28dfc9048417df7028] ipw2x00: change defau=
lt policy for auto-associate
git bisect bad 5c7f9b7363bfd10e40cf1a28dfc9048417df7028

e6a9854b05c1a6af1308fe2b8c68f35abf28a3ee is first bad commit
commit e6a9854b05c1a6af1308fe2b8c68f35abf28a3ee
Author: Johannes Berg=20
Date:   Tue Oct 21 12:40:02 2008 +0200

    mac80211/drivers: rewrite the rate control API

    So after the previous changes we were still unhappy with how
    convoluted the API is and decided to make things simpler for
    everybody. This completely changes the rate control API, now
    taking into account 802.11n with MCS rates and more control,
    most drivers don't support that though.

    Signed-off-by: Felix Fietkau=20
    Signed-off-by: Johannes Berg=20
    Signed-off-by: John W. Linville=20

:040000 040000 d53bb98b64c968e4c7a352d3ada6fe059980ff98 fa431af31a6904e=
9aef5d501b028fef46def07b5 M      drivers
:040000 040000 5508f50aa57a9d8a7247be6dda9c545f032dbe36 7b718ad01d2b737=
1855af224447f3519b2d636c7 M      include
:040000 040000 35f1ef3a607c1614f3c157446cfd3d8daf102ce2 39f88cd0644e67e=
f4fb3e69d2e80f14687ac3641 M      net


_________________________________________________________________
 25GB of FREE Online Storage =96 Find out more
http://clk.atdmt.com/UKM/go/134665320/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
