Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:56836 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBKGRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 01:17:47 -0500
Received: by mail-bk0-f41.google.com with SMTP id na10so2092778bkb.14
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 22:17:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392052405-15337-1-git-send-email-marek.puzyniak@tieto.com>
References: <1392052405-15337-1-git-send-email-marek.puzyniak@tieto.com>
Date: Tue, 11 Feb 2014 07:17:45 +0100
Message-ID: <CA+BoTQ=q-940AsMfneU5SP8Ke1RxEZE12rrm4Z+KBaTBjrW64w@mail.gmail.com> (sfid-20140211_071804_358352_4145CD5F)
Subject: Re: [PATCH] ath10k: change simulate_fw_crash to work with 10.1 firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 February 2014 18:13, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> Wmi command WMI_FORCE_FW_HANG_CMDID is not supported
> in firmware 10.1. In order to have firmware crash simulation
> functionality also in firmware 10.1 driver can force firmware
> crash by performing not allowed operation. Driver can deliberately
> crash firmware when setting vdev param for vdev id out of range.
>
> Command to trigger firmware crash:
> echo "crash" > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> ---

The 'fw hang assert' crash can be recovered with a warm reset but a
real crash can't. Thus, I think the two crash methods should be
distinguishable by having either two separate debugfs files or two
separate trigger keywords.


Michał
