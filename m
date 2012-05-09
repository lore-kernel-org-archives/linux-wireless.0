Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52598 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2EIQdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 12:33:01 -0400
Received: by vbbff1 with SMTP id ff1so463274vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 09:33:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 May 2012 12:33:00 -0400
Message-ID: <CABF+-6UWRy+KZMOFo12z3n7hPjWH-mUN203nQq_0rNb1Yjj7dg@mail.gmail.com> (sfid-20120509_183307_249290_38873003)
Subject: [PATCHv2 12/21] cw1200: sta.*, mac80211 STA callbacks.
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

>+			priv->conf_listen_interval =
>+				(*((u16 *)pElement->data+1) >> 7) & 0x1F;

The above code in the cw1200_parse_SDD_file function does not appear
to take into account the endianess of the host.  Is this a problem?


Best regards,

Kevin
