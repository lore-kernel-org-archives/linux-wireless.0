Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:51911 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbcBHQUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 11:20:31 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
Date: Mon, 8 Feb 2016 11:20:24 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Message-Id: <F8D31DB3-94AF-47CC-8091-7B6478983B53@holtmann.org> (sfid-20160208_172036_391841_E606E064)
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com> <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
To: =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joa Paulo,

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

as explained in an earlier response, the concept Airplane Mode seems to be imposing policy into the kernel. Do we really want have this as a kernel exposed API.

Regards

Marcel

