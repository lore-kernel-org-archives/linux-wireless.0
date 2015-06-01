Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36190 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbFAONr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 10:13:47 -0400
Received: by igbpi8 with SMTP id pi8so62252658igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 07:13:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433166856-3285-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1433166856-3285-1-git-send-email-Wojciech.Dubowik@neratec.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 2 Jun 2015 00:13:25 +1000
Message-ID: <CAGRGNgW=qy2TuojGt5CDE0sATkKeMTHCtBJnFQOjJ=3pP7Kzzw@mail.gmail.com> (sfid-20150601_161455_772652_A8F38FB1)
Subject: Re: [PATCH] mac80211: Fix double locking on CSA counter update
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wojciech,

On Mon, Jun 1, 2015 at 11:54 PM, Wojciech Dubowik
<Wojciech.Dubowik@neratec.com> wrote:
> We call rcu locked ieee80211_csa_update_counter from
> already locked section. Fix it by decrementing counter
> directly instead of calling ieee80211_csa_update_counter.

Stupid question: wouldn't it be better to split the work from
ieee80211_csa_update_counter() into a separate function without
locking and call that instead?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
