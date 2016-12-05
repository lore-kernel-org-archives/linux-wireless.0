Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33563 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbcLERX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 12:23:58 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so1290087ioi.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 09:23:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5845827B.2000000@candelatech.com>
References: <1480645800-2148-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQkEaC-ZSbeK=JB=q+ucF1PWcEQXkJEp6JYv4pfOf35cHg@mail.gmail.com>
 <1480945950.31788.4.camel@sipsolutions.net> <58458058.5020008@candelatech.com>
 <1480950054.31788.36.camel@sipsolutions.net> <5845827B.2000000@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 5 Dec 2016 09:23:56 -0800
Message-ID: <CAJ-VmokNztn7Rj4jTxYo2QR0vL0-t6h7M5qLKUSMn2-VtAN2bA@mail.gmail.com> (sfid-20161205_182401_565382_FAA25436)
Subject: Re: [PATCH 1/2] mac80211: do not iterate active interfaces when in re-configure
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Michal Kazior <michal.kazior@tieto.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fwiw, I'm facing the same kinds of cleanup problems with my port of
(oct 2015) ath10k to freebsd.

The oct 2015 ath10k tree doesn't have the firmware per-txq/tid/peer
feedback stuff in it, so this hasn't yet bitten me, but there rest of
the races have - mostly surrounding handling pending TX frames when a
VAP is deleted (vdev/interface in ath10k/mac80211 language) and if any
TX frames were stuck. Stuck TX frames happens more often than I'd like
because of how earlier firmware required peer entries to first appear
in the hardware.

Maybe we need some kind of lifecycle checkpoint for things like peer
addition/removal (for the txq issues ben had before) and the ability
to ask the firmware to stop/flush HTT TX and re-start it. That way we
can cleanly add/remove interfaces at any point without worrying about
any dangling frames in the transmit queue waiting for completion.



-adrian
