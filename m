Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35688 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbDMIl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 04:41:59 -0400
Received: by wgyo15 with SMTP id o15so72929547wgy.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 01:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428672203-8604-5-git-send-email-michal.kazior@tieto.com>
References: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com>
	<1428672203-8604-5-git-send-email-michal.kazior@tieto.com>
Date: Mon, 13 Apr 2015 10:41:57 +0200
Message-ID: <CA+BoTQmdJOYzYgfZq68tqr4G+PJKSvOvWRiDp=esMzv1vuS+jw@mail.gmail.com> (sfid-20150413_104202_916825_CC17CA87)
Subject: Re: [PATCH 4/4] ath10k: enable ibss-rsn
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2015 at 15:23, Michal Kazior <michal.kazior@tieto.com> wrote:
> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> With latest additions to the driver it seems
> viable to enable support for IBSS-RSN.
>
> It seems to work on QCA988X and 999.999.0.636 but
> is a bit slow to exchange RSN keys for some
> reason. This may be a firmware quirk or ath10k is
> missing something. Nevertheless it makes sense to
> finally enable IBSS-RSN in ath10k even if somewhat
> handicapped.
>
> QCA6174 firmware doesn't seem to be able to Tx
> EAPOL frames at all now (they get stuck in hw
> queues for some reason) so it never gets to set
> the keys in driver. It's fairly safe to assume that
> once this is fixed IBSS-RSN will work with QCA6174
> firmware without any additional changes. Hence no
> special handling for advertising
> IEEE80211_HW_SUPPORTS_PER_STA_GTK and
> WIPHY_FLAG_IBSS_RSN is done now.

As a matter of fact QCA6174 firmware does seem to work with IBSS as
well. I just found out (by accident, after leaving a failed test setup
for a while) that after approx. 300 seconds firmware discards all
stuck EAPOL frames and starts sending subsequent ones properly. Keys
gets exchanged, installed and traffic seems to work fine with this
patchset. I suppose this warrants an updated commit log.


Michał
