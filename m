Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35908 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbKWGGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 01:06:44 -0500
Received: by ykdr82 with SMTP id r82so225877812ykd.3
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 22:06:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151122191508.GB31884@w1.fi>
References: <1446477028-23118-1-git-send-email-chaitanya.mgit@gmail.com> <20151122191508.GB31884@w1.fi>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 23 Nov 2015 11:36:25 +0530
Message-ID: <CABPxzYKo9YJctjF41d9qWW1fm5D-Y-q9m5GYhYxeB+wL45o3pA@mail.gmail.com> (sfid-20151123_070648_892376_80A11DB8)
Subject: Re: [PATCHv2] offchannel: Cancel the pending_action TX wait, before
 starting new one.
To: Jouni Malinen <j@w1.fi>
Cc: hostap@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 12:45 AM, Jouni Malinen <j@w1.fi> wrote:
>
> On Mon, Nov 02, 2015 at 08:40:28PM +0530, Chaitanya T K wrote:
> > From: tkc <chaitanya.mgit@gmail.com>
> >
> > Before the tx_status is received for the action frame, if we
> > get another request, we respond to that by freeing the memory
> > for pending_action_tx, but we don't cancel the TX wait, so
> > in the kernel the ROC will not be cancelled.
> >
> > Due to above issue, wpa_supplicant assumes that all pending
> > RoC's are cancelled and proceeds with interface creation and
> > connection, where as state in mac80211/driver will be roc_in_progress.
> >
> > This is leading to issues at driver level.
> >
> > Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> > ---
> > V2: Fix 2 from's.
> >     Remove the unnecessary braces.
>
> I'm not sure I'd call that "From:" in the message body fixed (i.e., it
> should have been the second one, not the first one; alternatively, it
> would be fine to remove that From: line from the message body since the
> one in the message header has a value matching that SOB).
>
Sure will remove From.

>
> > diff --git a/wpa_supplicant/offchannel.c b/wpa_supplicant/offchannel.c
> > @@ -253,15 +253,9 @@ int offchannel_send_action(struct wpa_supplicant *wpa_s, unsigned int freq,
> >
> >       wpa_s->pending_action_tx_status_cb = tx_cb;
> >
> > -     if (wpa_s->pending_action_tx) {
> > -             wpa_printf(MSG_DEBUG, "Off-channel: Dropped pending Action "
> > -                        "frame TX to " MACSTR " (pending_action_tx=%p)",
> > -                        MAC2STR(wpa_s->pending_action_dst),
> > -                        wpa_s->pending_action_tx);
> > -             wpa_hexdump_buf(MSG_MSGDUMP, "Pending TX frame",
> > -                             wpa_s->pending_action_tx);
> > -             wpabuf_free(wpa_s->pending_action_tx);
> > -     }
> > +     if (wpa_s->pending_action_tx)
> > +             offchannel_send_action_done(wpa_s);
>
> As noted in your reply to this, those debug prints should not be
> removed.
>
> As far as the change to offchannel_send_action_done() is concerned, I'm
> not sure it is the correct thing to do in all cases. Why would we cancel
> Action frame TX wait or remain-on-channel if the new frame is for the
> same channel?
>
I think wpa_supplicant can start the RoC, the FSM in mac80211
will check whether to start a new or continue the old depending on
the channel and time.
