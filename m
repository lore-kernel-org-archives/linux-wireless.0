Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51417 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1KUGwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 01:52:36 -0500
Received: by eye27 with SMTP id 27so4977305eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 22:52:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALGY4fsaHGp3cZxTGPpxyjnjD4QorFgsNmUfAFN=Pfi1tQtamA@mail.gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
	<CAD2nsn2AWuTOJyufUFP+iS5PobMubjqQ-q52mvYfENr1WriJSg@mail.gmail.com>
	<CALGY4fsaHGp3cZxTGPpxyjnjD4QorFgsNmUfAFN=Pfi1tQtamA@mail.gmail.com>
Date: Mon, 21 Nov 2011 12:22:33 +0530
Message-ID: <CAD2nsn0T9-QedxCfBfPqD_UEDBY+=tRj_C+R6m7hJW+Y=OLyLw@mail.gmail.com> (sfid-20111121_075239_938176_F8A9695E)
Subject: Re: [PATCH 0/4] Fix the way ANI is being disabled for ar9100 and ar9340
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 11:22 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> Hi,
>
> 2011/11/21 Mohammed Shafi <shafi.wireless@gmail.com>:
>
>>>  Question: there are common.disable_ani (and corresponding debugfs file) and config.enable_ani in ath9k code. config.enable_ani sets if ANI is supported and common.disable_ani is meant to disable calibration. This is confusing on a sense that disable_ani completely disables all calibration code including short/long calibration and ANI, not ANI alone. Would it make sense to rename disable_ani to disable_calib and enable_ani to ani_supported?
>>
>> I understand short and long calibration of ANI, not the complete calibration :)
>> disable_ani is to stop/start ANI anytime via ath9k debugfs entry.
>> please let me know if you have further queries
>
>  I'm new to this code so I hope you'll forgive me if my question
> sounds stupidly.
>  There is 'ath_ani_calibrate' which basically does three things
> (apart from timer management boilerplate):
>   -- calls ath9k_hw_calibrate to perform 'long calibration'
>   -- calls ath9k_hw_calibrate to perform 'short calibration'
>   -- calls ath9k_hw_ani_monitor to get ANI statistics (?)
>  So there seem to be three major parts of ANI: long calibration,
> short calibration, and third thing which I find hard to name correctly
> so I'll refer to it as 'ANI-ANI'.

thanks! yes yes you are correct, sorry i made a mistake. based on
longcal/shortcal flags we call ath9k_hw_calibrate. true
ath9k_hw_ani_monitor does the real ani and updating ofdm/cck error and
all other ANI statistics


>
>  From your response I understand that 'short calibration' and 'long
> calibration' generally considered to be part of think called ANI.
> Considering this name 'disable_ani' in a sense that it disables
> 'ath_ani_calibrate' as a whole looks ok.
>  But config.enable_ani is used to control if 'ANI-ANI' gets executed
> (and this was somewhat true before my patch).
>  So, having two variables which 'negated' names is confusing by
> itself, i.e. enable_ani vs disable_ani. But more confusing is the fact
> that they actually control different things and have different
> meaning, so disable_ani != (!enable_ani).

true disable_ani completeley disables all the three things long/short
cal and hw_ani_monitor.

>
>  I do understand that my 'ANI-ANI' probably has proper name and I
> think that 'enable_ani' should probably be renamed using this proper
> name.

true, enable_ani only takes care of ath9k_hw_ani_monitor.  thanks for
digging into it.

>
>  I'd really appreciate if you could let me know where my
> understanding is incorrect.
>  Thanks!
>
> --
> Truthfully yours,
> Martynov Nikolay.
> Email: mar.kolya@gmail.com
>



-- 
shafi
