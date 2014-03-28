Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44835 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaC1Ncc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:32:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so755175wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:32:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396012109.4175.26.camel@jlt4.sipsolutions.net>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-8-git-send-email-michal.kazior@tieto.com>
	<1396012109.4175.26.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Mar 2014 14:32:30 +0100
Message-ID: <CA+BoTQ=dxCyiOamh3qHWXsxGsPvWE=ex6Uq=FfBBjcXbi5GgCg@mail.gmail.com> (sfid-20140328_143235_590599_A0449B3C)
Subject: Re: [PATCH v2 07/13] mac80211: improve find_chanctx() for reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2014 14:08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
>> Relax ieee80211_find_chanctx(). If chanctx
>> reservation chandef is compatible with
>> current-future assigned interfaces chandef then
>> allow it to be used by new interfaces.
>
> Err, I don't understand. Could you elaborate?

Yeah. Me too. Apparently I fail at English.

Basically this allows new vifs to be assigned to a chanctx as long as
chanctx's reservation chandefs *and* chanctx's current chandef
(implied by assigned vifs, if any) *and* the new vif chandef are
compatible. chanctx being used for in-place reservation with
conflicting channels are skipped. This also it makes it possible to
assign a vif to a chanctx that has been created for reservation only
(that hasn't been finalized yet) and has no vifs assigned whatsoever.


Michał
