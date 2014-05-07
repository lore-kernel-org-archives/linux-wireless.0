Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:36470 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaEGHfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:35:09 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so573108wev.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399387428.4218.45.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-4-git-send-email-michal.kazior@tieto.com>
	<1399387428.4218.45.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 09:35:07 +0200
Message-ID: <CA+BoTQnLh7Oq+40YfQtwhiDwNdaHN4sU_XSWZTr8EfVG421-HA@mail.gmail.com> (sfid-20140507_093513_778520_D3C37D2D)
Subject: Re: [PATCH v4 3/5] mac80211: use chanctx reservation for STA CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 16:43, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
>> Channel switch finalization is now 2-step. First
>> step is when driver calls chswitch_done(), the
>> other is when reservation is actually finalized
>> (which be defered for in-place reservation).
>>
>> It is now safe to call ieee80211_chswitch_done()
>> more than once.
>>
>> Also remove the ieee80211_vif_change_channel()
>> because it is no longer used.
>
> A lot of this looks really duplicated from the previous patch - since I
> just merged the fixes is there really a need to go through the work etc.
> and have this different, instead of going through cfg80211 for the
> disconnect?

I'm not really sure what duplication you refer to? There were already
a couple of uses of csa_connection_drop_work so I used it too. It
might make sense now to use cfg80211_stop_iface() instead but I'd
argue it's better to do that as a follow up patch.


Michał
