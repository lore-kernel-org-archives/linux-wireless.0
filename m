Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63202 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1DGTUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 15:20:32 -0400
Received: by wya21 with SMTP id 21so2506280wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 12:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110406133151.GB2197@redhat.com>
References: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
	<1301966140-26080-2-git-send-email-thomas@cozybit.com>
	<20110406133151.GB2197@redhat.com>
Date: Thu, 7 Apr 2011 12:17:14 -0700
Message-ID: <BANLkTikK+KKwwbb-FkQHjEeXX3qvQf7hWA@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
From: Thomas Pedersen <thomas@cozybit.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2011 at 6:31 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Apr 04, 2011 at 06:15:31PM -0700, Thomas Pedersen wrote:
>> -     /* first allocate the new vendor information element */
>> +     /* allocate information elements */
>>       new_ie = NULL;
>> -     old_ie = ifmsh->vendor_ie;
>> +     old_ie = ifmsh->ie;
>>
>> -     ifmsh->vendor_ie_len = setup->vendor_ie_len;
>> -     if (setup->vendor_ie_len) {
>> -             new_ie = kmemdup(setup->vendor_ie, setup->vendor_ie_len,
>> +     ifmsh->ie_len = setup->ie_len;
>> +     if (setup->ie_len) {
>> +             new_ie = kmemdup(setup->ie, setup->ie_len,
>>                               GFP_KERNEL);
>>               if (!new_ie)
>>                       return -ENOMEM;
>
> No idea if this is a problem, but in !new_ie case, after function
> exit ifmsh->ie_len will not match ifmsh->ie .
>
Yes you are right, good catch. This will be fixed in next resubmission.

> Stanislaw
>
>
