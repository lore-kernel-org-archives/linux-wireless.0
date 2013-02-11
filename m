Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:53320 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3BKWLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 17:11:45 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so2868373bku.13
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 14:11:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360617645.8738.42.camel@jlt4.sipsolutions.net>
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
 <1360616843-24618-3-git-send-email-thomas@cozybit.com> <1360617645.8738.42.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 11 Feb 2013 14:11:23 -0800
Message-ID: <CAG6hwVMY9KE1tR4kqy+8DF2mOd2zKxhYS_km6P2g8m5nDgCQpA@mail.gmail.com> (sfid-20130211_231149_012654_B8BCD941)
Subject: Re: [PATCH 3/3] mac80211: generate mesh probe responses
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 1:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-02-11 at 13:07 -0800, Thomas Pedersen wrote:
>
>> +     if (elems.mesh_id_len != 0 &&
>> +         (elems.mesh_id_len != ifmsh->mesh_id_len ||
>> +          memcmp(elems.mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len))) {
>> +             mpl_dbg(sdata, "ignoring probe request for different MBSS\n");
>
>> +     presp = dev_alloc_skb(local->tx_headroom +
>> +                           bcn->head_len + bcn->tail_len);
>> +     if (WARN_ON(!presp))
>> +             goto out;
>
> same as before.
>
>
>> +     mpl_dbg(sdata, "sending probe resp. to %pM\n", hdr->da);
>
> I also think you should probably drop both mpl_dbg() statements as
> they're likely to just be noise for any other debugging when you
> actually use this?

OK. I'll replace them with sdata_info() then.

-- 
Thomas
