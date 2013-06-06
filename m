Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2137 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab3FFVKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 17:10:36 -0400
Message-ID: <51B0FAC0.4080709@broadcom.com> (sfid-20130606_231039_977040_1A72CE10)
Date: Thu, 6 Jun 2013 23:10:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Regression in 9390ace brcmfmac: free net device when
 registration fails
References: <51AD1F22.2080004@wwwdotorg.org>
 <51ADE47D.50700@broadcom.com>
In-Reply-To: <51ADE47D.50700@broadcom.com>
Content-Type: multipart/mixed;
 boundary=------------020803010208010103040403
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------020803010208010103040403
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 06/04/13 14:58, Arend van Spriel wrote:
> On 06/04/2013 12:56 AM, Stephen Warren wrote:
>> (John, note that this commit is part of the pull request you sent to
>> Dave today)
>>
>> Arend,
>>
>> Commit 9390ace "brcmfmac: free net device when registration fails"
>> causes a regression.
>>
>> I had the BCM4330 firmware present in my root fs, whereas my HW is a
>> BCM4329. With this patch applied, I get a kernel panic on boot. With it
>> reverted, I see that no issues of that nature. This is true in
>> next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
>> Linus's tree followed by a merge of John's wireless pull request from
>> today pointed at this same commit.
>
> Thanks, Stephen
>
> I will look into this.

Hi Stephen,

Can you try the attached patch? If it does not solve the issue, could 
you provide a log.

>> Related: Since the two hardware require different firmware, I wonder why
>> the driver doesn't use a firmware filename that encodes the HW device ID
>> instead of using the same name for all HW. This means that when I move
>> my SD card between development systems, I have to copy different
>> firmware over the top. That's a little painful...
>
> I agree that for development switching cards it is kinda awkward and I
> have been fooled by it as well. We may want to change or if your itch is
> annoying enough feel free to send a patch for it ;-)

We have a patch for this that we can submit to wireless-next.

Regards,
Arend

--------------020803010208010103040403
Content-Type: text/plain;
 name=0001-brcmfmac-free-primary-net_device-when-brcmf_bus_star.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0=0001-brcmfmac-free-primary-net_device-when-brcmf_bus_star.pa;
 filename*1=tch

>From 2c0bf2dc8ecf91175a4b9a28dc2c4e84aceee4cf Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Thu, 6 Jun 2013 22:43:41 +0200
Subject: [PATCH] brcmfmac: free primary net_device when brcmf_bus_start()
 fails

When initialization within brcmf_bus_start() fails on steps
before the brcmf_net_attach() the net_device for the primary
interface needs to be freed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 63cadf6..d7cf98e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -941,6 +941,10 @@ fail:
 			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
 		}
+		if (drvr->iflist[0]) {
+			free_netdev(ipf->ndev);
+			drvr->iflist[0] = NULL;
+		}
 		if (p2p_ifp) {
 			free_netdev(p2p_ifp->ndev);
 			drvr->iflist[1] = NULL;
-- 
1.7.10.4


--------------020803010208010103040403--

