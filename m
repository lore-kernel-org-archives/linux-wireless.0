Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:55388 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbYHTP5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 11:57:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so262348nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2008 08:57:08 -0700 (PDT)
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling through rfkill (v6)
Date: Wed, 20 Aug 2008 17:57:04 +0200
Cc: LKML <linux-kernel@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, linux-wireless@vger.kernel.org
References: <48AB8902.3010406@overt.org>
In-Reply-To: <48AB8902.3010406@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808201757.04501.IvDoorn@gmail.com> (sfid-20080820_175717_565738_31B2B673)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> +	if (unlikely(state_changed)) {
> +		rfkill_force_state(dev->rfk_dev,
> +				   new_rfk_state ?
> +				   RFKILL_STATE_SOFT_BLOCKED :
> +				   RFKILL_STATE_HARD_BLOCKED);
> +		input_report_switch(poll_dev->input, SW_RFKILL_ALL, new_rfk_state);
> +	}
> +}

This looks very nice, but is the switch really toggling between
soft and hard blocked only? ;)

I mean shouldn't there be some unblock signal at some point?

Ivo
