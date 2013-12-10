Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47610 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3LJRFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 12:05:37 -0500
Received: by mail-ie0-f180.google.com with SMTP id tp5so8718742ieb.25
        for <linux-wireless@vger.kernel.org>; Tue, 10 Dec 2013 09:05:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>
References: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>
Date: Tue, 10 Dec 2013 19:05:36 +0200
Message-ID: <CAB3XZEfwLk5PUp34hQ_8Uog6T8BHRP6akW4SThjXjgAQRAhC-Q@mail.gmail.com> (sfid-20131210_180542_836236_AC9E9306)
Subject: Re: [RFC 1/2] mac80211: iterate over vif using RCU
From: Eliad Peller <eliad@wizery.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Tue, Dec 10, 2013 at 6:39 PM, Antonio Quartulli
<antonio@meshcoding.com> wrote:
> I need to invoke ieee80211_iter_keys() from a periodic worker in a driver and
> therefore I would prefer to get rid of any of locks to avoid problems.
> These two patches try to use rcu lock to protect the iteration, but I'd like to
> get a feedback before sending this stuff as a patch :-)
>
at least iwlwifi might sleep inside the iterator, so you can't just
convert it to rcu (atomic).

> Moreover, why do we use list_for_each_entry_safe() is ieee80211_iter_keys() if
> the list cannot be altered (pointer to key is not passed to iter() so we should
> be sure that nobody is going to invoke list_del())?

see the documentation of ieee80211_remove_key():
/**
 * ieee80211_remove_key - remove the given key
 * @keyconf: the parameter passed with the set key
 *
 * Remove the given key. If the key was uploaded to the hardware at the
 * time this function is called, it is not deleted in the hardware but
 * instead assumed to have been removed already.
 *
 * Note that due to locking considerations this function can (currently)
 * only be called during key iteration (ieee80211_iter_keys().)
 */

Eliad.
