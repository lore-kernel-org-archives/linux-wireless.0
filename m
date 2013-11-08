Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13512 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3KHNl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 08:41:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: Marek Puzyniak <marek.puzyniak@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add phyerr/dfs handling
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
	<87bo1xuajk.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=oj2hg6zRf5rKyDBexWOdR08=aRXRJtD9gQQs7i_tjjMQ@mail.gmail.com>
Date: Fri, 8 Nov 2013 15:41:22 +0200
In-Reply-To: <CALhHN=oj2hg6zRf5rKyDBexWOdR08=aRXRJtD9gQQs7i_tjjMQ@mail.gmail.com>
	(Janusz Dziedzic's message of "Wed, 6 Nov 2013 14:52:09 +0100")
Message-ID: <87habnau4d.fsf@kamboji.qca.qualcomm.com> (sfid-20131108_144131_692682_7AB7E2DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> On 6 November 2013 10:47, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Marek Puzyniak <marek.puzyniak@tieto.com> writes:
>>
>>> +     struct ath10k *ar = file->private_data;
>>> +     char *buf;
>>> +
>>> +     buf = kzalloc(size, GFP_KERNEL);
>>> +     if (buf == NULL)
>>> +             return -ENOMEM;
>>> +
>>> +     if (!ar->dfs_detector) {
>>> +             len += scnprintf(buf + len, size - len, "DFS not enabled\n");
>>> +             goto exit;
>>> +     }
>>> +
>>> +     ar->debug.dfs_pool_stats = ar->dfs_detector->get_stats(ar->dfs_detector);
>>
>> I think we need to take conf_mutex to make sure ar->dfs_detector is not
>> destroyed while we use it.
>>
> We deregister dfs_detector in ath10k_mac_unregister() so we will first
> destroy debugfs, then we don't need any mutex here. BTW I see we don't
> call debugfs_remove*() - so, currently mac clear debugfs for us -
> ieee80211_unregister_hw() -> wiphy_unregister I think. After that we
> deregister dfs_detector.

I don't have the code at hand but yeah, that sounds sensible.

>>> +static void ath10k_dfs_radar_report(struct ath10k *ar,
>>> +                                 struct wmi_single_phyerr_rx_event *event,
>>> +                                 struct phyerr_radar_report *rr,
>>> +                                 u64 tsf)
>>> +{
>>> +     u32 reg0, reg1, tsf32l;
>>> +     struct pulse_event pe;
>>> +     u64 tsf64;
>>> +     u8 rssi, width;
>>
>> What about locking? Does this function assume that conf_mutex is held?
>> If yes, please document that with lockdep_assert_held(). If no, we have
>> a problem :)
>>
>> (Reads wmi.c)
>>
>> Ah, wmi events don't sleep anymore, forgot that. So we can't really use
>> conf_mutex here. I guess our options are bring back worker for wmi
>> events or use spinlock.
>
> I think we can use here spin_lock_bh(&ar->data_lock) when setting
> ar->debug.dfs_stats and when reading this from debugfs.
> But, is that really needed (in worst case we will get older values via debugfs)?

I would prefer not to have any race conditions in the driver, even if
it's just statistics. If there's only a race with statistics atomic
variables are also one option.

-- 
Kalle Valo
