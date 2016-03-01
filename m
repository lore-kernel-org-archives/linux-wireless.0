Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33342 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcCAImQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 03:42:16 -0500
Received: by mail-io0-f170.google.com with SMTP id n190so12062107iof.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 00:42:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456739065-470-1-git-send-email-arend@broadcom.com>
References: <1456739065-470-1-git-send-email-arend@broadcom.com>
Date: Tue, 1 Mar 2016 10:42:15 +0200
Message-ID: <CAB3XZEehKfMzRgfbDkwWieKrzAAXwBcNbAMNGfhn6qBRAktGdA@mail.gmail.com> (sfid-20160301_094219_833498_D90406F3)
Subject: Re: [PATCH V10 1/2] nl80211: add feature for BSS selection support
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 29, 2016 at 11:44 AM, Arend van Spriel <arend@broadcom.com> wrote:
> Introducing a new feature that the driver can use to
> indicate the driver/firmware supports configuration of BSS
> selection criteria upon CONNECT command. This can be useful
> when multiple BSS-es are found belonging to the same ESS,
> ie. Infra-BSS with same SSID. The criteria can then be used to
> offload selection of a preferred BSS.
>
[...]

> +       /* only do bss selection when no BSSID is specified. */
> +       if (!connect.bssid && info->attrs[NL80211_ATTR_BSS_SELECT]) {
> +               if (connect.bssid) {

i guess you wanted to remove the !connect.bssid condition in the outer if :)
other than that, looks go to me.

Eliad.
