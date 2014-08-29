Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:12111 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaH2OSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 10:18:24 -0400
Message-ID: <54008BAD.9050904@broadcom.com> (sfid-20140829_161828_295318_05B35EF5)
Date: Fri, 29 Aug 2014 16:18:21 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Brain WrecK <bloften80@gmail.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43241b4-sdio NVRAM help request
References: <53FDAC24.1070205@broadcom.com>	<CAA1t8StpW6rh+by6tbjy71Bhx+6UyPTQtQ61jDGU03rGm4EgXA@mail.gmail.com> <CAA1t8SsAE4F=W4Tu+7bgLJ-oaXmBmtwv_xYMDe4GYxu0CdjQMA@mail.gmail.com>
In-Reply-To: <CAA1t8SsAE4F=W4Tu+7bgLJ-oaXmBmtwv_xYMDe4GYxu0CdjQMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/14 06:51, Brain WrecK wrote:
> sorry to keep sending you logs, but this one is complete from
> deactivating to reactivating with the debug, want to make sure you have
> all the info you need
>
> let me know if you need anything else

Please keep replying to all (including Cc:).

Did you disable runtime-pm for the mmc host controller with bcm43241 
device. From your log I see the driver tells the firmware to join 
"BRAINNET 1" but wpa_supplicant times out after 10 seconds. I suspect 
the host controller went in runtime suspend so the connect events from 
the firmware are not processed until wpa_supplicant gives up and host 
initiates interaction with the device.

The controller should be somewhere under 
/sys/bus/acpi/drivers/sdhci-acpi/. If you have the correct controller 
there is a power subfolder. Check the control file:

$ cat control

If it says auto, change it to 'on':

echo 'on' > control

When done, load brcmfmac.

Regards,
Arend
> thanks for your help
>
>
>
>
> On Thu, Aug 28, 2014 at 9:18 PM, Brain WrecK <bloften80@gmail.com
> <mailto:bloften80@gmail.com>> wrote:
>
>     Hello again
>
>     i realized i did not have the debug features enabled for the brcm
>     devices so i compiled a new kernel, this is version 3.17.rc2 and
>     here is the log output i could get from the modprobe brcmfmac
>     'debug=0xd416'
>
>
>
>
>     On Wed, Aug 27, 2014 at 4:00 AM, Arend van Spriel
>     <arend@broadcom.com <mailto:arend@broadcom.com>> wrote:
>
>         + linux-wireless
>
>         Please keep Cc: There may be more people with Asus T100
>         interested in this.
>
>
>         -------- Original Message --------
>         Subject: Re: Broadcom 43241b4-sdio NVRAM help request
>         Date: Tue, 26 Aug 2014 22:24:00 -0600
>         From: Brain WrecK <bloften80@gmail.com <mailto:bloften80@gmail.com>>
>         To: Arend van Spriel <arend@broadcom.com
>         <mailto:arend@broadcom.com>>
>
>
>
>         Thank you so much for taking the time out of your vacation to
>         respond, i
>         hope you have nice weather and sunny skies from now on, you
>         certainly
>         brightened my day by offering your help
>
>         using stock ubuntu kernel
>
>         here is the info you requested, i am currently using ubuntu
>         14.10 with
>         Ubuntu-3.17rc2 with the NVRAM file from /sys/firmware/efi/efivars/
>
>         thank you once again for offering your help
>
>         please let me know if you need any more information
>
>         i can also provide the information from a 3.16 kernel, if you
>         need it
>
>         thank you again
>
>         Brian Loften
>
>
>
>
>         On Tue, Aug 26, 2014 at 2:51 AM, Arend van Spriel
>         <arend@broadcom.com <mailto:arend@broadcom.com>
>         <mailto:arend@broadcom.com <mailto:arend@broadcom.com>>> wrote:
>
>         On 08/24/14 10:06, Brain WrecK wrote:
>
>         Hello Sir
>
>         I am writing this request to ask for your aid, we have been
>         tryng to get
>         ubuntu 14.10 to run on an ASUS T100TA tablet and we are having
>         wifi issues
>
>         I am appealing to you and to ask for your help as i have been
>         trying for
>         weeks to get this wifi working stable, i have been trying to
>         modify the
>         NVRAM file to get a stable connection so we can have decent working
>         internet on this tablet to enjoy the Linux experience. right now
>         currently we can download in the range of 600 bytes/sec to maybe
>         10kb/sec
>
>         We are unable to connect with the current NVRAM file provided
>         from the
>         NVRAM file unless we put our current MAC address for our wifi
>         card in
>         the brcmfmac43241b4-sdio.txt
>
>         and once we do that we are able to connect but we get frequent
>         disconnects and very very slow download rates...
>
>         I have pulled the NVRAM from the efivars in sys/firmware/efivars and
>         have attached it for you is there perhaps an updated file that will
>         work, or would you be able to help us and create a new or provide a
>         current NVRAM File?
>
>         Also the firmware that is provided for us is dated july 17th 2013 is
>         there an updated linux firmware that we can use for this device that
>         perhaps would have an updated NVRAM file to go with it?
>
>         I have attached the firmware that is provided for us as well for
>         your
>         reference
>
>         I am sure you are a busy person and we in the linux community
>         would love
>         to be rid of windows and enjoy the linux experience, could you,
>         would
>         you lend us your aid?
>
>
>         Hi Brian,
>
>         Sure I can try to be somewhat helpful. I am currently on vacation
>         and rain is pouring down in buckets.
>
>         The nvram that is in EFI should be the perfect fit for the device.
>         Maybe you can provide some more background info. Are you using stock
>         ubuntu kernel. What kernel version is running? Can you boot the
>         kernel with 'debug ignore_loglevel' parameters, load the brcmfmac
>         driver with 'debug=0xd416', and send me the full kernel log.
>
>         Regards,
>         Arend
>
>
>
>

