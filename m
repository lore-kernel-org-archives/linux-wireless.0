Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.nl.porthus.com ([212.72.53.30]:57902 "EHLO
	mail-out2.nl.porthus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3CHIcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 03:32:54 -0500
From: =?Windows-1252?Q?Ale=9A_Voda?= <AVoda@descartes.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: AR6103G Linux kernel 3.4.5 problems
Date: Fri, 8 Mar 2013 08:26:44 +0000
Message-ID: <99DFDBE1-6AE2-41BB-9B38-FC27061345E8@descartes.com> (sfid-20130308_093258_667928_D73D4312)
References: <62813611608FC749AC8F3F91AEAF5F89417512DD@CPEXM03.corp.dsg.local>,<87ppzas663.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ppzas663.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPhone

On 8. mar. 2013, at 08:27, "Kalle Valo" <kvalo@qca.qualcomm.com> wrote:

> Hi,
> 
> Aleš Voda <AVoda@descartes.com> writes:
> 
>> We have some custom board equipped with AR6103G using SDIO as hif and
>> are having problems with AR6103 not starting after downloading the
>> firmware. Linux kernel being used is 3.4.5. As it is apparent from the
>> console output attached, the fw related files are downloaded and a
>> timeout occurs after uploading data patch file to the chip. After
>> removing ath6kl_sdio driver and renaming fw-2 and fw-3
> 
> Why do you need to rename the firmware files? What version of ath6kl are
> you using? Where did you get it? 
> 
I haven't renamed files except for the data file. I had to rename one of three bdata files, otherwise I got error from the driver that it wasn't able to load the bdata file, because it couldn't find it. I tried all combinations fw-3.bin only without athwlan.bin, fw-2.bin without athwlan.bin and so on but without success ;-(
I downloaded ath6kl FW from kernel firmware git repository and I'm using linux kernel 3.4.5 downloaded from kernel source tree, I know that you use some other repository for downloading Kernel but I also downloaded that before we were introduced and made a diff with my kernel on ath6kl drivet and there are practically no changes between the two in loading and powering up the modulei to the point where my module doesn't reply anymore? If you downloaded F ath6kl FW from some other repository, could you please tell me the URL?
>> are so they can not be found and loaded, timeout during fw uploads
>> doesn't occur anymore after insertion of the ath6kl_sdio module, but
>> there is a HW startup failure while awaiting CTRL message from the
>> chip (err = -EIO). The firmware for the chip has been downloaded from
>> the kernel firmware git repository.
>> 
>> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=tree;f=
>> ath6k/AR6003/hw2.1.1;hb=HEAD
> 
> You should be using fw-3.bin. Better to remove athwlan.bin and fw-2.bin
> altogether from your platform.

I actually did that. As explained above I tried different combinations also using fw-2.bin or fw-3.bin without athwlan.bin being present in the corresponding FW folder. But things were even worse ;-(
> 
>> What could be the problem? If you need any additional info please do
>> not hesitate to contact me.
> 
> I think I don't have AR6103 myself. I'm not sure if it has some
> differences compared to AR6003, that's one possibility as well.
> 
> -- 
> Kalle Valo

Thank you very much again for your help ;-)

Best Regards,
Ales