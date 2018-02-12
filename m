Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933072AbeBLMoY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 07:44:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Timothy Redaelli <tredaelli@redhat.com>
Cc: <linux-wireless@vger.kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: fix DFS detector synchronization
References: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
        <87fu6aegmy.fsf@kamboji.qca.qualcomm.com>
        <20180209153311.193e08e0@redhat.com>
Date: Mon, 12 Feb 2018 14:44:19 +0200
In-Reply-To: <20180209153311.193e08e0@redhat.com> (Timothy Redaelli's message
        of "Fri, 9 Feb 2018 15:33:11 +0100")
Message-ID: <877eri9y3g.fsf@kamboji.qca.qualcomm.com> (sfid-20180212_134431_066595_C999C8E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timothy Redaelli <tredaelli@redhat.com> writes:

> On Fri, 09 Feb 2018 10:01:09 +0200
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Timothy Redaelli <tredaelli@redhat.com> writes:
>> 
>> > The code currently syncronize the DFS region only if curchan != 0,
>> > but hostapd launch DFS before the channel is set and so
>> > set_dfs_domain is never executed.
>> >
>> > CC: Felix Fietkau <nbd@nbd.name>
>> > Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>  
>> 
>> What kind of bug does this fix? Please describe the symptoms from
>> user's point of view.
>
> With the current code radar detection (CAC) doesn't work on ath9k
> since "dpd_set_domain" is only called once with NL80211_DFS_UNSET (0) as
> region and so "dpd_add_pulse" always returns true (radar detected)
> without doing a real scan.
>
> You can test it easily with a kernel built with
> CONFIG_ATH9K_DFS_CERTIFIED and by using a simple hostapd configuration:
>
> interface=wlp1s0
> hw_mode=a
> channel=acs_survey
> chanlist=100 104 108 112 116 120 124 128 132 136 140
> ieee80211d=1
> ieee80211h=1
> country_code=US
> ieee80211n=1
> wmm_enabled=1
> ssid=testwifi

Any ideas what broke this? Or has it never worked with FCC (US)?

Anyway, please add this info to the commit log and submit v2.

-- 
Kalle Valo
