Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57695 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3LKRjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 12:39:07 -0500
Received: by mail-wi0-f178.google.com with SMTP id bz8so1236510wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 09:39:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131207035407.GA19456@pe-lt052.marvell.com>
References: <20131207035407.GA19456@pe-lt052.marvell.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 11 Dec 2013 18:38:44 +0100
Message-ID: <CAB=NE6Xs7mgp6oM4VTXHjKGgPnsPz5v=2O4LwPKu=Cm4V4P7fw@mail.gmail.com> (sfid-20131211_183955_925811_0F6E5815)
Subject: Re: [RFC] cfg80211: set regulatory request processed for initiator core
To: Avinash Patil <patila@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 7, 2013 at 4:54 AM, Avinash Patil <patila@marvell.com> wrote:
> During cfg80211 init, cfg80211 initializes regulatory to set to
> world domain. Here we dont set last request processed flag.
> This results into further request set to pending indefinitely.
>
> This patch fixes this by setting last request to processed.
>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  net/wireless/reg.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index ec54e1a..70a8f0a 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1670,6 +1670,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>         switch (reg_request->initiator) {
>         case NL80211_REGDOM_SET_BY_CORE:
>                 reg_process_hint_core(reg_request);
> +               nl80211_send_reg_change_event(reg_request);
> +               reg_set_request_processed();
>                 return;
>         case NL80211_REGDOM_SET_BY_USER:
>                 treatment = reg_process_hint_user(reg_request);

NACK, the reg_process_hint() is supposed to *process* a request, and
then call the internal regdb if its there and also call CRDA. Later
whoever sends the regulatory domain and gets cfg80211 to process it
will have reg_set_request_processed() called.

Can you verify if CRDA is sending the regulatory domains to cfg80211?

  Luis
