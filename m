Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1BORbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 12:31:36 -0500
Received: by yxt3 with SMTP id 3so199069yxt.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 09:31:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297771986.3935.9.camel@jlt3.sipsolutions.net>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-5-git-send-email-njs@pobox.com>
	<1297685871.3785.39.camel@jlt3.sipsolutions.net>
	<AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
	<1297771986.3935.9.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Feb 2011 09:31:34 -0800
Message-ID: <AANLkTimKeh=ZxM-tVLc60tyXHnX9s7=UxBsFkvv4VgMZ@mail.gmail.com>
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize latency
From: Nathaniel Smith <njs@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 4:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-02-14 at 13:58 -0800, Nathaniel Smith wrote:
>> I don't know. I take it you're imagining a scheme where mac80211 keeps
>> a hash table or similar of all packets that have been queued to the
>> device, and does its own tx rate estimation and calls start/stop_queue
>> as needed? If that works, then it would be lovely. (Heck, it should
>> probably go in the generic net layer eventually; ethernet cards have
>> the same problem.)
>
> Well, no, why would it keep a hash table??

The current patch, whenever it queues a packet, stores
  t = the current time
  S = the current size of the queue
so that later when the TX completes, it can compute (now - t)/S to
estimate the per-packet transmission time. I just mean that you'd need
somewhere to store this stuff, or else find another algorithm for rate
estimation.

-- Nathaniel
