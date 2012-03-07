Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:34908 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759211Ab2CGEQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 23:16:08 -0500
Message-ID: <4F56E0FB.70109@posedge.com> (sfid-20120307_051612_822922_B870BAAF)
Date: Wed, 07 Mar 2012 09:45:55 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: requesting information on null frame send during scan in mac80211
 - linux 3_1_4 code base
References: <7596c51dab245e8f5cb1e3010943e28b@posedge.com> <CAD2nsn3yp9KetFQHpeLq2R1S_brY=3u+wznCdeGh6i8qwvYCvw@mail.gmail.com>
In-Reply-To: <CAD2nsn3yp9KetFQHpeLq2R1S_brY=3u+wznCdeGh6i8qwvYCvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

thanks for the reply. yes, i looked into the latest code and understand 
the working now. thanks for the input. it really helped

thanks and regards
vivek



On 03/06/2012 09:20 PM, Mohammed Shafi wrote:
> On Sat, Mar 3, 2012 at 12:09 AM,<vivekanandah@posedge.com>  wrote:
>> hi,
> hi vivekanandah,
>
>> i am new to the linux system and i am hoping that this is the right list to
>> mail for my query.
>>
>> I am presently working on linux kernel 3.1.4 and i was looking into the
>> mac80211 code and the scan implementation on the same.
> the present wireless-testing scan state machine is simplified by the
> johannes's patch
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/80287
> and easy to understand
>
>> when the scan process is started, the station is supposed to send a null
>> frame with PM bit set, so that AP can buffer frames to the station.
>>
>> However, it is seen in code that when scan is initiated (software scan),
>> the ieee80211_offchannel_enable_all_ps(local, false); function is called,
>> since the flag is set to false, the NULL frame will not be sent out. also,
>> when the scan state changes to leaving operating channel, the vifs interface
>> is blocked. even here, i see that the flag setting is false for offchannel
>> Power save and the null frame is not sent out.
> the current wireless-testing tree does this. please look at
> ieee80211_start_sw_scan
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>
>> the comment however just prior to the vifs stop function call indicates that
>> offchannel settings are already completed at the start of scan process. the
>> code snippet is shown below:
>>
>> /*PS will already be in off-channel mode, we do that once at the beginning
>> of scanning.*/
>> ieee80211_offchannel_stop_vifs(local, false);
>>
>> i just would like to know why the flag is FALSE in both cases, so we never
>> send out a null frame to the AP at the start. is this a bug or there is some
>> deficiency in my current understanding?
> based on my limited understanding of the previous code, my guess we
> have in ieee80211_work in work.c and this should send a null func
> frame. (both started and tmp_channel will be false and NULL
>
> if (on_oper_chan != on_oper_chan2) {
> 				if (on_oper_chan2) {
> 					/* going off oper channel, PS too */
> ---->  					ieee80211_offchannel_stop_vifs(local,
> 								       true);
> 					ieee80211_hw_config(local, 0);
> 				} else {
> 					/* going on channel, but leave PS
>
> its best to look at the current wireless-testing tree code, its more simpler.
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

