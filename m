Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47630 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab0I3Q1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 12:27:09 -0400
Received: by pvg2 with SMTP id 2so546880pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 09:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009250002.21219.chunkeey@googlemail.com>
References: <201009210057.13297.chunkeey@googlemail.com>
	<20100924180013.GD8077@tuxdriver.com>
	<201009250002.21219.chunkeey@googlemail.com>
Date: Thu, 30 Sep 2010 12:27:08 -0400
Message-ID: <AANLkTikqRuDVwhxhXkpA3c5ppzVu_HhkaEUhyr+YBUMy@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
From: Bob Copeland <me@bobcopeland.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 6:02 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:

> hard to say, smatch must see the null dereference, when
> we receive an action action frame where ftype is PLINK_OPEN
> and the mesh_matches_local(&elems, sdata) check fail, but why
> doesn't it complain about the "spin_lock_bh(&sta->lock)"?

Smatch just does pattern matching right?  Maybe smatch doesn't
assume you are actually using the pointer in spin_lock_bh().

I.e. it is ok to do "&null_ptr->member", offsetof() basically
does that; but not "null_ptr->member".

-- 
Bob Copeland %% www.bobcopeland.com
