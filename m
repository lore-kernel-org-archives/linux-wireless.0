Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37969 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0CRPLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 11:11:21 -0400
Received: by fxm19 with SMTP id 19so2210606fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 08:11:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
	 <1268758859.2446.595.camel@rchatre-DESK>
	 <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
Date: Thu, 18 Mar 2010 16:11:19 +0100
Message-ID: <6cf6b73e1003180811w5c577652i308b4d4e06b6011a@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
From: Adel Gadllah <adel.gadllah@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/18 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Tue, Mar 16, 2010 at 10:00:59AM -0700, reinette chatre wrote:
>> On Sun, 2010-03-14 at 11:44 -0700, Adel Gadllah wrote:
>> > From 83bf3f1dba41e3dccdef4fecfccb094559568342 Mon Sep 17 00:00:00 2001
>> > From: Adel Gadllah <adel.gadllah@gmail.com>
>> > Date: Sun, 14 Mar 2010 19:16:25 +0100
>> > Subject: [PATCH] iwlwifi: Silence tfds_in_queue message
>> >
>> > Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
>> > noisy message, that fills up the log very fast.
>> >
>> > The error seems not to be fatal (the connection is stable and
>> > performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.
>> >
>> > Cc: Reinette Chatre <reinette.chatre@intel.com>
>> > Cc: John W. Linville <linville@tuxdriver.com>
>> > Cc: stable@kernel.org
>> >
>> > Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
>>
>> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
>
> Actually I would like to NACK the patch.
>
> We did mistake during backporting to 2.6.32 . In iwl_tx_queue_reclaim()
> we make make double nfreed--. I don't know how we miss that :(
>
> Greg please take patch from the next email if Adel conform that
> it fix the issue.

Yeah not sure that making it a debug message is a bad idea though (but
even if we want that it doesn't matter much for stable).
