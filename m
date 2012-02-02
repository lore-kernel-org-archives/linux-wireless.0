Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47051 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2BBPN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 10:13:56 -0500
Received: by dadp15 with SMTP id p15so1910455dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 07:13:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328181189-5461-1-git-send-email-eliad@wizery.com>
References: <1328181189-5461-1-git-send-email-eliad@wizery.com>
Date: Thu, 2 Feb 2012 16:13:55 +0100
Message-ID: <CAGXE3d8z54m0Jh68U9r6qeVOiAuF6S8e2vWQP8NtNajUW1pD0A@mail.gmail.com> (sfid-20120202_161400_042496_48B4D108)
Subject: Re: [PATCH] mac80211: support hw scan while idle
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 12:13 PM, Eliad Peller <eliad@wizery.com> wrote:
[...]
> -       if (local->scan_sdata) {
> +       if (local->scan_sdata &&
> +           !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {

Maybe check for the existence of the hw_scan callback here? Otherwise a
driver setting this flag without providing a hw_scan callback might cause
trouble ...

Helmut
