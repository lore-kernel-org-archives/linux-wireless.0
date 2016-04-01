Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38362 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbcDAGSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 02:18:23 -0400
Received: by mail-wm0-f52.google.com with SMTP id 20so9558395wmh.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 23:18:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459457986-29222-2-git-send-email-greearb@candelatech.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
	<1459457986-29222-2-git-send-email-greearb@candelatech.com>
Date: Fri, 1 Apr 2016 08:18:21 +0200
Message-ID: <CA+BoTQmR_ziondh_bdEfQMC1jezGO6ioVSiMB3G4uGXvr5eKaw@mail.gmail.com> (sfid-20160401_081826_427314_C73AB273)
Subject: Re: [PATCH 2/3] ath10k: Ensure peer_map references are cleaned up.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2016 at 22:59,  <greearb@candelatech.com> wrote:
[...]
> @@ -812,6 +813,15 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
>                         ar->peer_map[peer_id] = NULL;
>                 }
>
> +               /* Double check that peer is properly un-referenced from the peer_map */
> +               for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
> +                       if (ar->peer_map[i] == peer) {
> +                               ath10k_warn(ar, "ERROR:  Faile to properly clean up peer: %p %pM, idx: %d, will fix.\n",
> +                                           peer, peer->addr, i);

The message doesn't fit the style and has typos. I think it's more
in-line with the preceeding warning to:
  "removing stale peer_map entry for %pM (ptr %p idx %d)"


[...]
> @@ -850,6 +861,11 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
>                 list_del(&peer->list);
>                 kfree(peer);
>         }
> +
> +       /* Clean up peer-map */

No need for the comment.

> +       for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++)
> +               ar->peer_map[i] = NULL;

Could use memset() as well?


Anyway, thanks for catching these! :)


Michał
