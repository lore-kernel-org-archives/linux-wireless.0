Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbaCECby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 21:31:54 -0500
Date: Wed, 5 Mar 2014 03:31:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	frankyl@broadcom.com
Subject: Re: brcmfmac NVRAM files
Message-ID: <20140305023151.GG17664@zurbaran> (sfid-20140305_033157_653722_E3117FA6)
References: <20140217150640.GJ18868@zurbaran>
 <20140217163315.GA22010@zurbaran>
 <53023E51.90202@Uni-Oldenburg.DE>
 <530248DD.1050408@broadcom.com>
 <20140217180033.GM18868@zurbaran>
 <53032EAB.5070905@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53032EAB.5070905@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, Feb 18, 2014 at 10:58:03AM +0100, Arend van Spriel wrote:
> I certainly hope you misread that. Before 3.13 the driver always look
> for brcmfmac-sdio.bin and brcmfmac-sdio.txt regardless the device being
> used. That has changed so the firmware file now includes the chip id and
> for some even the revision, eg. brcmfmac43241b4-sdio.bin and
> brcmfmac43241b4-sdio.txt. The nvram file has a totally different format
> as the bin file so copying will fail for sure.
So I finally found this NVRAM file, hidden somewhere in an EFI variable
(Thanks for the hint).
I have 2 questions for you:

- How can I tell if the target properly loaded this NVRAM file ? Is
  checking for wlan0's MAC to match the NVRAM MAC a good way to verify
  that ?

- I'm running this on an Asus T100 (x86 tablet). This is a BCM94324A1
  over SDIO and I run wireless-next there (With your very latest
  brcmfmac changes). I see the driver is quite unreliable, for example
  scan times out most of the time as the driver puts the target to sleep
  while it's in the middle of receiving partial scan results. I had to
  increase BRCMF_WD_POLL_MS to 100ms to actually get scan results. Then
  the driver seems to be having a hard time joining the couple of WPA
  APs that I tested it against.
  Am I missing something or are those instabilities to be expected with
  the latest brcmfmac code ? Please let me know if you need debug logs,
  I'll happily provide them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
