Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61576 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaCKHqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 03:46:11 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so8293405oag.28
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 00:46:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	<1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
Date: Tue, 11 Mar 2014 08:46:10 +0100
Message-ID: <CA+BoTQkke050EMs0Nnz3O3XM6U2uRRVrxffVdwKJrWua+iapFw@mail.gmail.com> (sfid-20140311_084615_620199_A0D0D61B)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2014 12:19, Michal Kazior <michal.kazior@tieto.com> wrote:
> It doesn't make much sense to have a manually
> managed chanctx refcount. It isn't performance
> critical and it can't be even used outside the
> protection of chanctx_mtx.
>
> With future enhancements to channel contenxt
> (namely reservations) refcount accounting will
> become more complex and having manually managed
> refcount is going to be error-prone and confusing.
>
> The refcount is now equal to the number of vifs it
> is assigned to. However in the future this will
> change so keep the refcount/num_assigned_vifs
> functions split now.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Self-NACK.

I totally missed how ieee80211_remove_interfaces() works. It removes
all interfaces from the list in one go before each is actually
stopped. This means refcount computes 0. IOW If you unload a driver
with multiple interfaces running you get a nice general protection
fault (multiple ieee80211_free_chanctx calls).

I'm planning on adding `struct list_head` to sdata and chanctx to be
able to iterate over assigned (and reserved, in the future) chanctx.
What do you think? Do you have other ideas?


Michał
