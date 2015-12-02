Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52181 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbbLBUf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 15:35:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7E22120524
	for <linux-wireless@vger.kernel.org>; Wed,  2 Dec 2015 20:35:28 +0000 (UTC)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id CACAC2051D
	for <linux-wireless@vger.kernel.org>; Wed,  2 Dec 2015 20:35:27 +0000 (UTC)
Received: by oies6 with SMTP id s6so33273271oie.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2015 12:35:27 -0800 (PST)
MIME-Version: 1.0
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 2 Dec 2015 12:35:07 -0800
Message-ID: <CALCETrWP=cv_3Q6BheFm=edFfSJ6Vs5NdeMtRJrBBk6bFQuoTQ@mail.gmail.com> (sfid-20151202_213536_551578_ED371454)
Subject: Invalid SPLX
To: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi-

My laptop has SPLC implemented like this:

        Name (SPLX, Package (0x04)
        {
            Zero,
            Package (0x03)
            {
                0x80000000,
                0x80000000,
                0x80000000
            },

            Package (0x03)
            {
                0x80000000,
                0x80000000,
                0x80000000
            },

            Package (0x03)
            {
                0x80000000,
                0x80000000,
                0x80000000
            }
        })
        Method (SPLC, 0, Serialized)
        {
            Index (DerefOf (Index (SPLX, One)), Zero) = DOM1 /* \DOM1 */
            Index (DerefOf (Index (SPLX, One)), One) = LIM1 /* \LIM1 */
            Index (DerefOf (Index (SPLX, One)), 0x02) = TIM1 /* \TIM1 */
            Index (DerefOf (Index (SPLX, 0x02)), Zero) = DOM2 /* \DOM2 */
            Index (DerefOf (Index (SPLX, 0x02)), One) = LIM2 /* \LIM2 */
            Index (DerefOf (Index (SPLX, 0x02)), 0x02) = TIM2 /* \TIM2 */
            Index (DerefOf (Index (SPLX, 0x03)), Zero) = DOM3 /* \DOM3 */
            Index (DerefOf (Index (SPLX, 0x03)), One) = LIM3 /* \LIM3 */
            Index (DerefOf (Index (SPLX, 0x03)), 0x02) = TIM3 /* \TIM3 */
            Return (SPLX) /* \_SB_.PCI0.RP14.PXSX.SPLX */
        }

splx_get_power_limit rejects this because it has more than one entry.
I don't see a spec for SPLC, but I'd guess that splx_get_power_limit
should iterate all the entries to find one that indicates wifi.

Also, should this be in common code instead of just in iwleifi?

--Andy
