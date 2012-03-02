Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60968 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab2CBVSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:18:14 -0500
Received: by iagz16 with SMTP id z16so2806408iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 13:18:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330722711.8542.26.camel@jlt3.sipsolutions.net>
References: <1330722280-28879-1-git-send-email-javier@cozybit.com>
 <1330722280-28879-2-git-send-email-javier@cozybit.com> <1330722711.8542.26.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 2 Mar 2012 13:17:54 -0800
Message-ID: <CAPjQAd_Pnpvwqti4faMB2svacbjg3Z4PvEq_fg3v4jJMC5sAaA@mail.gmail.com> (sfid-20120302_221825_132512_4A30A7ED)
Subject: Re: [PATCHv3 2/2] mac80211: Modify tsf via debugfs in mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 2, 2012 at 1:11 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-02 at 13:04 -0800, Javier Cardona wrote:
>
>>  static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
>>  {
>> -     return cpu_to_le64(jiffies_to_msecs(jiffies)*1000/1024 +
>> -                     data->tsf_offset);
>> +     struct timeval tv = ktime_to_timeval(ktime_get_real());
>> +     u64 now = (u64) tv.tv_sec * MSEC_PER_SEC + tv.tv_usec / USEC_PER_MSEC;
>> +     return cpu_to_le64(now + data->tsf_offset);
>> +}
>
> Oh.
>
> But now you're giving it in MSEC, you want USEC.

I changed tea brands this week and it shows.  v4 in a few minutes.

j





-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
