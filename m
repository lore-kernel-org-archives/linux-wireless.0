Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:30869 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYGQLd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 07:33:29 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2863509ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 04:33:27 -0700 (PDT)
Message-ID: <f6ca9fed0807170433m5199b66bl7e8bafd1002c566e@mail.gmail.com> (sfid-20080717_133334_299673_2586B8D7)
Date: Thu, 17 Jul 2008 13:33:27 +0200
From: drago01 <drago01@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 4/4] rfkill: mutex fixes
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200807170656.37190.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
	 <1216150327-10904-5-git-send-email-hmh@hmh.eng.br>
	 <200807170656.37190.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 6:56 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
>> There are two mutexes in rfkill:
>>
>> rfkill->mutex, which protects some of the fields of a rfkill struct, and is
>> also used for callback serialization.
>>
>> rfkill_mutex, which protects the global state, the list of registered
>> rfkill structs and rfkill->claim.
>>
>> Make sure to use the correct mutex, and to not miss locking rfkill->mutex
>> even when we already took rfkill_mutex.

rfkill_state_mutex ?
