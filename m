Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46904 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0BIMaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 07:30:23 -0500
Received: by vws12 with SMTP id 12so264959vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 04:30:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265717634.3783.35.camel@johannes.berg>
References: <1265707228-4813-1-git-send-email-vnatarajan@atheros.com>
	 <1265717634.3783.35.camel@johannes.berg>
Date: Tue, 9 Feb 2010 18:00:22 +0530
Message-ID: <8e92b4101002090430m7cd18016qd0fcc310f179c7eb@mail.gmail.com>
Subject: Re: [PATCH v6] mac80211: Retry null data frame for power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 9, 2010 at 5:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2010-02-09 at 14:50 +0530, Vivek Natarajan wrote:
>> Even if the null data frame is not acked by the AP, mac80211
>> goes into power save. This might lead to loss of frames
>> from the AP.
>> Prevent this by restarting dynamic_ps_timer when ack is not
>> received for null data frames.
>
> Looks good to me, but I have a final question: what happens if the frame
> is lost without a status report? It'll just stay out of PS for a while
> longer, right?

Yes, it will be awake and then retries once again after a while.

Vivek.
