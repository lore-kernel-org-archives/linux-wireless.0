Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38535 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZELP3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 11:29:08 -0400
Received: by gxk10 with SMTP id 10so75449gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 08:29:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242110389.3873.53.camel@johannes.local>
References: <200905120109.09906.chunkeey@web.de>
	 <1242110389.3873.53.camel@johannes.local>
Date: Tue, 12 May 2009 11:29:08 -0400
Message-ID: <b6c5339f0905120829l4e78f71ep73e28d0e9118ed2e@mail.gmail.com>
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 2:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> =A0 =A0 =A0 if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ar9170_stop_and_flush_queues(ar);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> Why don't you do that in the pre-scan method?

Will pre-scan be called once per scan or once for every channel switch?
If the former, I think it's not the right place to flush.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
