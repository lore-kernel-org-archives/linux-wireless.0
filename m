Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0JMWbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:31:32 -0400
Received: by fxm4 with SMTP id 4so2042024fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:31:31 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 17:31:31 -0500
Message-ID: <AANLkTikcnYd9ekwcqpMw_WiQ1DAXe7UGJHKOi2Y14edv@mail.gmail.com>
Subject: estimated_retx ?
From: Joel Fernandes <agnel.joel@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was wondering what the meaning of this line of code in mesh_hwmp.c
in function airtime_link_metric_get is:

        estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));

The computation is : 1 / ( 1 - error rate )

Does the variable name imply "estimated retransmissions" ?

Also the err variable is calculated as a moving average based on the
ACK of every frame tx.
It is my understanding that err should be error rate (no.of bit errors
per second). How then can a moving average be considered as errors
*per second* ?

thanks,
Joel
