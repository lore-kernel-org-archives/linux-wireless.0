Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:21650 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYE0GlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 02:41:13 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2529177waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 23:41:13 -0700 (PDT)
Message-ID: <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com> (sfid-20080527_084124_263733_92B21A8B)
Date: Tue, 27 May 2008 09:41:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 8:13 AM, Joonwoo Park <joonwpark81@gmail.com> wrote:
> Fix overflow which is occured by long wep key configuring.
> Also, this patch contains some cleanup for not to do memcpy with
> zero size.
>
> $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
>

WEP key is of fixed size 13 or  5 bytes, this setting should be
refused somewhere in the mac wext handler.
NACK.
Tomas
