Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4114 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab3BXKVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 05:21:54 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: RE: [RFC 00/13] brcmsmac: add AP mode
Date: Sun, 24 Feb 2013 10:21:13 +0000
Message-ID: <A47087626F2942499CF47E79803E771E0431BF4D@SJEXCHMB13.corp.ad.broadcom.com> (sfid-20130224_112207_703318_8F4F56C3)
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, February 24, 2013 2:05 AM, Hauke Mehrtens wrote:
> This patch series contains some cleanup patches for brcmsmac and then
> adds beacon and probe response template upload.
> With these features AP mode support is added in the last patch.

Someone was bound to start on this and we are lately too focussed on
brcmfmac. We will review the patches and found out whether our test
framework can cover AP mode.

> When running AP mode in 5GHz band on my BCM43224 I get the following
> errors, and I do not see the network with my Intel IWL6300, the
> regulation restrictions in channel.c where changed before:

5GHz is a bit tricky. I will need to find out whether AP mode can work with
the current ucode.

> [  829.608000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait:
> waited 83000 uS and MI_MACSSPNDD is still not on.
> [  829.616000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff808d, phydebug
> 0x0000000d, psm_brc 0x0000

It generally indicates a hang in the ucode. Are you using the firmware from
the linux-firmware repository?

> The probe responses are currently send by the ucode based on the
> template and by mac80211. I was searching for a switch so disable probe
> request forwarding from the ucode to the driver.

I am pretty sure there is. I will look into this and let you know.

> The structure of brcmsmac is pretty complicated, because it copies many
> addresses into its own structs and does not use mac80211 structs in
> main.c.

Yeah. Basically, a lot of conversions are done at mac80211 interface to keep
the low-level driver code similar to the code base it came from. That is the
path taken. I would like to see a replacement driver some day that shares more
structure definitions with the linux wireless subsystem, but for now that is just
me daydreaming ;-)

Regards,
Arend
