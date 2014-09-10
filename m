Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36476 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaIJE6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 00:58:14 -0400
Received: by mail-la0-f50.google.com with SMTP id ty20so5592671lab.23
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 21:58:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org>
References: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com>
	<85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org>
Date: Wed, 10 Sep 2014 07:58:13 +0300
Message-ID: <CANUX_P2sVqw=e8ZG5NnMme+TfsjXB36ymMUDUkzp90nB4cPdnw@mail.gmail.com> (sfid-20140910_065821_567058_ACC8F5B6)
Subject: Re: [PATCH] cfg802111/nl80211: Add device motion indication API
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Avraham Stern <avraham.stern@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> if we have WiFi chips that have these kind of information, then shouldn't it be better exposed via a generic subsystem for motion events. Having this exposed over nl80211 seems a bit too limited.
>
> I am thinking that either an input event or maybe via hwmon or IIO. Since at the end of the day such an event should be considered just a sensor. It doesn't matter which piece of hardware is doing the sensing or who it is doing for.
>
> We are also not exposing RFKILL switches over nl80211. We have a dedicated RFKILL subsystem where all kinds of switches can integrate into.
>

I can't sayI totally disagree, but the point here I guess is that the
precision is very limited - WiFi based after all - and hence, I don't
think we really want to expose a real motion detection device to the
whole system. This is not a gyro or anything of this kind. The commit
message gives example of use cases where the flows that are triggered
by this kind of notifications. The user aren't aware of these flows.
The frequency of the scan isn't something the user is aware of but
more a WiFi system parameter. So basically, I don't think we can
really talk about a real sensor, but more of a heuristic that will
likely help WiFi to behave better. Might there be other components
interested in this heuristic with its level of (im)precision, good
question.
Maybe adding this to the description of the command would help?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
