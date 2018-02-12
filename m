Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:53724 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752281AbeBLP1G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 10:27:06 -0500
Subject: Re: [PATCH] ath9k: fix DFS detector synchronization
To: Kalle Valo <kvalo@codeaurora.org>,
        Timothy Redaelli <tredaelli@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>
References: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
 <87fu6aegmy.fsf@kamboji.qca.qualcomm.com>
 <20180209153311.193e08e0@redhat.com>
 <877eri9y3g.fsf@kamboji.qca.qualcomm.com>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <d6f093b1-ddba-a8d0-e007-aea996e16110@neratec.com> (sfid-20180212_162714_137230_E0988FAA)
Date: Mon, 12 Feb 2018 16:27:05 +0100
MIME-Version: 1.0
In-Reply-To: <877eri9y3g.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2018 01:44 PM, Kalle Valo wrote:
> Timothy Redaelli <tredaelli@redhat.com> writes:
> 
>> On Fri, 09 Feb 2018 10:01:09 +0200
>> Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>>> Timothy Redaelli <tredaelli@redhat.com> writes:
>>>
>>>> The code currently syncronize the DFS region only if curchan != 0,
>>>> but hostapd launch DFS before the channel is set and so
>>>> set_dfs_domain is never executed.
>>>>
>>>> CC: Felix Fietkau <nbd@nbd.name>
>>>> Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>  
>>>
>>> What kind of bug does this fix? Please describe the symptoms from
>>> user's point of view.
>>
>> With the current code radar detection (CAC) doesn't work on ath9k
>> since "dpd_set_domain" is only called once with NL80211_DFS_UNSET (0) as
>> region and so "dpd_add_pulse" always returns true (radar detected)
>> without doing a real scan.
>>
>> You can test it easily with a kernel built with
>> CONFIG_ATH9K_DFS_CERTIFIED and by using a simple hostapd configuration:
>>
>> interface=wlp1s0
>> hw_mode=a
>> channel=acs_survey
>> chanlist=100 104 108 112 116 120 124 128 132 136 140
>> ieee80211d=1
>> ieee80211h=1
>> country_code=US
>> ieee80211n=1
>> wmm_enabled=1
>> ssid=testwifi
> 
> Any ideas what broke this? Or has it never worked with FCC (US)?
> 
> Anyway, please add this info to the commit log and submit v2.
> 

Hi,

the idea / reasoning behind setting the DFS detector's initial regulatory domain
to UNSET is a fail-safe mechanism to ensure a proper countrycode is set before the
CAC is initiated.

It used to work for a long time, but might broke when the regdb was moved into the
kernel and with that the initialization order between channel and regulatory
domain changed.


Not tested, but patch looks sane.
