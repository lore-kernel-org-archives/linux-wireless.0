Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:38280 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZIYTGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 15:06:55 -0400
Received: by bwz6 with SMTP id 6so152478bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 12:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ABBE0E6.4090408@gmx.de>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180251.14503.64152.stgit@tikku> <4ABBE0E6.4090408@gmx.de>
Date: Fri, 25 Sep 2009 12:06:58 -0700
Message-ID: <da94abde0909251206n4cbe6ed0n29b2c48c9729457a@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
From: Kalle Valo <kalle.valo@iki.fi>
To: Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 2:13 PM, Joerg Albert <jal2@gmx.de> wrote:
> On 09/24/2009 08:02 PM, Kalle Valo wrote:
>
>> +     len = sizeof(wiphy->fw_version);
>> +     snprintf(wiphy->fw_version, len, "%d.%d.%d-%d",
>> +              priv->fw_version.major, priv->fw_version.minor,
>> +              priv->fw_version.patch, priv->fw_version.build);
>> +
>> +     len = sizeof(wiphy->hw_version);
>> +     snprintf(wiphy->hw_version, len, "%d", priv->board_type);
>> +
>> +     /* null terminate the strings in case they were truncated */
>> +     wiphy->fw_version[len - 1] = '\0';
>> +     wiphy->hw_version[len - 1] = '\0';
>
> This only works as long as sizeof(wiphy->fw_version) == sizeof(wiphy->hw_version) - which is currently the case.
> For sizeof(wiphy->fw_version) < sizeof(wiphy_hw_version) it overwrites memory behind wiphy->fw_version.

Good point, thanks for catching that.

> IMHO this is more robust against changes in the lengths of the char arrays:
>
> +       wiphy->fw_version[sizeof(wiphy->fw_version) - 1] = '\0';
> +       wiphy->hw_version[sizeof(wiphy->hw_version) - 1] = '\0';

Actually Christian pointed out that snprintf() always null terminates
the string and all this unnecessary. So I'll just remove this in v2.

Kalle
