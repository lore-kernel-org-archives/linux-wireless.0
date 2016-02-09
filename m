Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33188 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbcBIWBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 17:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <1455053802-13063-1-git-send-email-jprvita@endlessm.com>
References: <CA+A7VXU9zoQZ5wM2Ranf7o9vUphGb0THkh8-TUM_1yD7aC30pQ@mail.gmail.com>
 <1455053802-13063-1-git-send-email-jprvita@endlessm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 10 Feb 2016 09:01:05 +1100
Message-ID: <CAGRGNgVwSPn4rc+19q7VVVL8V8zK=ubbF7in00HBYnsc1-WKWw@mail.gmail.com> (sfid-20160209_230154_913072_D2F14BE3)
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
To: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Wed, Feb 10, 2016 at 8:36 AM, João Paulo Rechi Vita
<jprvita@gmail.com> wrote:
> Provide an interface for the airplane-mode indicator be controlled from
> userspace. User has to first acquire the control through
> RFKILL_OP_AIRPLANE_MODE_ACQUIRE and keep the fd open for the whole time
> it wants to be in control of the indicator. Closing the fd or using
> RFKILL_OP_AIRPLANE_MODE_RELEASE restores the default policy.
>
> To change state of the indicator, the RFKILL_OP_AIRPLANE_MODE_CHANGE
> operation is used, passing the value on "struct rfkill_event.soft". If
> the caller has not acquired the airplane-mode control beforehand, the
> operation fails.
>
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>

This looks sane to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
