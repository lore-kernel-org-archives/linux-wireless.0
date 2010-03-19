Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35739 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0CSJWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 05:22:15 -0400
Received: by wwe15 with SMTP id 15so1667850wwe.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 02:22:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <6cf6b73e1003180811w5c577652i308b4d4e06b6011a@mail.gmail.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
	 <1268758859.2446.595.camel@rchatre-DESK>
	 <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
	 <6cf6b73e1003180811w5c577652i308b4d4e06b6011a@mail.gmail.com>
Date: Fri, 19 Mar 2010 10:22:14 +0100
Message-ID: <2d0a357f1003190222x27dcf885k9eff60c65492fc07@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Adel Gadllah <adel.gadllah@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

only to clarify:
There is no need for "iwlwifi: Silence tfds_in_queue message" patch
from wireless-2.6 GIT?
I mean "[2.6.32] iwlwifi: fix nfreed--" is enough for solving the
mentionned problem?

Kind Regards,
- Sedat -

On Thu, Mar 18, 2010 at 4:11 PM, Adel Gadllah <adel.gadllah@gmail.com> wrote:
> 2010/3/18 Stanislaw Gruszka <sgruszka@redhat.com>:
>> On Tue, Mar 16, 2010 at 10:00:59AM -0700, reinette chatre wrote:
>>> On Sun, 2010-03-14 at 11:44 -0700, Adel Gadllah wrote:
>>> > From 83bf3f1dba41e3dccdef4fecfccb094559568342 Mon Sep 17 00:00:00 2001
>>> > From: Adel Gadllah <adel.gadllah@gmail.com>
>>> > Date: Sun, 14 Mar 2010 19:16:25 +0100
>>> > Subject: [PATCH] iwlwifi: Silence tfds_in_queue message
>>> >
>>> > Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
>>> > noisy message, that fills up the log very fast.
>>> >
>>> > The error seems not to be fatal (the connection is stable and
>>> > performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.
>>> >
>>> > Cc: Reinette Chatre <reinette.chatre@intel.com>
>>> > Cc: John W. Linville <linville@tuxdriver.com>
>>> > Cc: stable@kernel.org
>>> >
>>> > Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
>>>
>>> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> Actually I would like to NACK the patch.
>>
>> We did mistake during backporting to 2.6.32 . In iwl_tx_queue_reclaim()
>> we make make double nfreed--. I don't know how we miss that :(
>>
>> Greg please take patch from the next email if Adel conform that
>> it fix the issue.
>
> Yeah not sure that making it a debug message is a bad idea though (but
> even if we want that it doesn't matter much for stable).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
