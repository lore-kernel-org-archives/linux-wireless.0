Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43694 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2CFPu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 10:50:28 -0500
Received: by vcqp1 with SMTP id p1so4503995vcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 07:50:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7596c51dab245e8f5cb1e3010943e28b@posedge.com>
References: <7596c51dab245e8f5cb1e3010943e28b@posedge.com>
Date: Tue, 6 Mar 2012 21:20:27 +0530
Message-ID: <CAD2nsn3yp9KetFQHpeLq2R1S_brY=3u+wznCdeGh6i8qwvYCvw@mail.gmail.com> (sfid-20120306_165031_567013_E208BD5B)
Subject: Re: requesting information on null frame send during scan in mac80211
 - linux 3_1_4 code base
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: vivekanandah@posedge.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 3, 2012 at 12:09 AM,  <vivekanandah@posedge.com> wrote:
> hi,

hi vivekanandah,

>
> i am new to the linux system and i am hoping that this is the right list to
> mail for my query.
>
> I am presently working on linux kernel 3.1.4 and i was looking into the
> mac80211 code and the scan implementation on the same.

the present wireless-testing scan state machine is simplified by the
johannes's patch
http://comments.gmane.org/gmane.linux.kernel.wireless.general/80287
and easy to understand

>
> when the scan process is started, the station is supposed to send a null
> frame with PM bit set, so that AP can buffer frames to the station.
>
> However, it is seen in code that when scan is initiated (software scan),
> the ieee80211_offchannel_enable_all_ps(local, false); function is called,
> since the flag is set to false, the NULL frame will not be sent out. also,
> when the scan state changes to leaving operating channel, the vifs interface
> is blocked. even here, i see that the flag setting is false for offchannel
> Power save and the null frame is not sent out.

the current wireless-testing tree does this. please look at
ieee80211_start_sw_scan
git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

>
> the comment however just prior to the vifs stop function call indicates that
> offchannel settings are already completed at the start of scan process. the
> code snippet is shown below:
>
> /*PS will already be in off-channel mode, we do that once at the beginning
> of scanning.*/
> ieee80211_offchannel_stop_vifs(local, false);
>
> i just would like to know why the flag is FALSE in both cases, so we never
> send out a null frame to the AP at the start. is this a bug or there is some
> deficiency in my current understanding?

based on my limited understanding of the previous code, my guess we
have in ieee80211_work in work.c and this should send a null func
frame. (both started and tmp_channel will be false and NULL

if (on_oper_chan != on_oper_chan2) {
				if (on_oper_chan2) {
					/* going off oper channel, PS too */
----> 					ieee80211_offchannel_stop_vifs(local,
								       true);
					ieee80211_hw_config(local, 0);
				} else {
					/* going on channel, but leave PS

its best to look at the current wireless-testing tree code, its more simpler.


>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
