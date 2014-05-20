Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:64856 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETHrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:47:20 -0400
Received: by mail-la0-f52.google.com with SMTP id gl10so66379lab.25
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:47:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399919689-31742-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1399919689-31742-1-git-send-email-rmanohar@qti.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 00:46:58 -0700
Message-ID: <CAB=NE6V_4u_7L3jW7kjMwWFx9=NfxZdWMuiFWCzEVSg6-+jTjg@mail.gmail.com> (sfid-20140520_094725_208668_3C4DAC71)
Subject: Re: [PATCH v3] cfg80211: avoid restoring the regulatory during disconnect
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2014 at 11:34 AM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> From: Sachin Ahuja <sahuja@codeaurora.org>
>
> When STA disconnects, cfg80211 restores the regulatory setting
> to world domain. For the drivers that ignore country ie, cfg80211
> should remain in the default country code which is configured
> at driver load and should do not be restored to world reg domain.
>
> Signed-off-by: Sachin Ahuja <sahuja@codeaurora.org>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
> v2: Removed is_all_countryie_ignore
> v3: Removed wdev_lock
>  net/wireless/sme.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 4bc21a2..031ab4c 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c

This approach is making the assumption that regulatory hint
disconnects should only be issued for devices that use country IEs
which I do not think should the place within the SME code, can you
instead stuff this handle this in net/wireless/reg.c ? For example --
beacon hints should be cleared even though the regulatory setting on
the device is not cleared. Your patch does not address that.

  Luis
