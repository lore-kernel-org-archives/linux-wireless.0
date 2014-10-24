Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55843 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbaJXKjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 06:39:01 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so811678wiv.8
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 03:39:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
	<1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
Date: Fri, 24 Oct 2014 12:39:00 +0200
Message-ID: <CA+BoTQm93OeqRf8a8xyEp4vDSNYtXvgE62rntYzSq+bsDKgZ2g@mail.gmail.com> (sfid-20141024_123909_728794_58F917A0)
Subject: Re: [PATCH 7/7] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 October 2014 14:58, Michal Kazior <michal.kazior@tieto.com> wrote:
> Latest firmware revision introduced a new WMI ABI
> called wmi-tlv. It is not a tlv strictly speaking
> but something that resembles it because it is
> ordered and may have duplicate id entries.
>
> This will be used by new hardware eventually.
[...]
> +struct wmi_tlv_peer_create_cmd {
> +       __le32 vdev_id;
> +       struct wmi_mac_addr peer_addr;
> +       __le32 peer_type;
> +};

Oops, this is missing __packed.


Michał
