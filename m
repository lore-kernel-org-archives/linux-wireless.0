Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51342 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab1L0PSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 10:18:36 -0500
Received: by vcbfk14 with SMTP id fk14so8967319vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2011 07:18:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324542989-25212-1-git-send-email-helmut.schaa@googlemail.com>
References: <1324542989-25212-1-git-send-email-helmut.schaa@googlemail.com>
Date: Tue, 27 Dec 2011 16:18:34 +0100
Message-ID: <CAOZOX0U5nx+8y5LGqW-4+-SG133GOcmcmjZpx5jq0Hgtug4eeA@mail.gmail.com> (sfid-20111227_161850_089678_78854ED3)
Subject: Re: [PATCH] rt2x00: Mark active channel's survey data as "in use"
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 9:36 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> This is just a cosmetical fix since we only return survey data for the
> active channel but it allows iw to show that the survey data is
> for the currently used channel.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 14fc8d1..bb70e89 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4686,6 +4686,9 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
>                survey->channel_time_ext_busy = busy_ext / 1000;
>        }
>
> +       if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
> +               survey->filled |= SURVEY_INFO_IN_USE;
> +
>        return 0;
>
>  }
> --
> 1.7.7
>
