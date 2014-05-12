Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45492 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaELHey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 03:34:54 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so3954543wib.11
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2014 00:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 12 May 2014 09:34:53 +0200
Message-ID: <CA+BoTQ=VxSu9q_w3tjMNikKxuiMAfW5=k9La_AK3PoP8azgFUA@mail.gmail.com> (sfid-20140512_093458_796090_35871187)
Subject: Re: [PATCH 0/7] ath10k: recovery improvements 2014-05-09
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 May 2014 14:35, Michal Kazior <michal.kazior@tieto.com> wrote:
> Hi,
>
> This depends on my `ath10k: recovery fixes
> 2014-05-09`.
>
> Hopefully the split makes it a little saner to
> review.
>
> Please note: `ath10k: make wmi timeout trigger hw
> restart` effectively hides the mgmt tx / htc
> credit starvation issue that was discussed
> recently. My intention is to make the driver more
> robust and as a side effect it makes the
> starvation issue less painful. If desired so
> the patch can be easily ignored in the series as
> nothing depends on it.
>
>
> Michal Kazior (7):
>   ath10k: move restart_work call
>   ath10k: introduce core restart symbol


>   ath10k: drain wmi quickly upon hw restart
>   ath10k: wake up everything on core restart

These 2 are harmful as they are. In case of early fw crash
uninitialized structures are accessed. I'll re-spin later.


Michał
