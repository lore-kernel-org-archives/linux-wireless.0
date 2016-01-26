Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34954 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbcAZK2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:28:21 -0500
Received: by mail-wm0-f54.google.com with SMTP id r129so97994947wmr.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 02:28:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnOfc-obhJR7woqg1=ZWBeOEDSQsaXTF1-wqH8V-Z-eRg@mail.gmail.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1453384006-31907-14-git-send-email-michal.kazior@tieto.com>
	<56A1182A.4060309@codeaurora.org>
	<CA+BoTQnOfc-obhJR7woqg1=ZWBeOEDSQsaXTF1-wqH8V-Z-eRg@mail.gmail.com>
Date: Tue, 26 Jan 2016 11:28:20 +0100
Message-ID: <CA+BoTQ=ujALZiD5njhd=4e6iASJpxUeL7Kh_Pe_1zbAe9hLYcw@mail.gmail.com> (sfid-20160126_112827_201074_BCAD2AAE)
Subject: Re: [PATCH 13/13] ath10k: implement push-pull tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@codeaurora.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2016 at 08:47, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 21 January 2016 at 18:40, Peter Oh <poh@codeaurora.org> wrote:
>> On 01/21/2016 05:46 AM, Michal Kazior wrote:
[...]
>>>   -     /* TODO: apply configuration */
>>> +       rcu_read_unlock();
>>> +
>>> +       spin_lock_bh(&ar->htt.tx_lock);
>>> +       ath10k_mac_tx_lock(ar, ATH10K_TX_PAUSE_Q_FLUSH_PENDING);
>>> +       spin_unlock_bh(&ar->htt.tx_lock);
>>> +
>>
>> Isn't it proved it break Mesh from working?
>
> Yes, good point. I'm still working on this - I should've mentioned
> that in the cover letter.
>
> Nonetheless I wanted to get the review process going for this patchset.
>
> I'll address the mesh problem in v2.

For the record - the problem turned out to be a bug in mac80211 mesh
fwding, see:

  https://patchwork.kernel.org/patch/8108711/


Michał
