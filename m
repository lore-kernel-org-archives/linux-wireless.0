Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57007 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0LVOVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:21:42 -0500
Received: by iwn9 with SMTP id 9so5264930iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:21:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293026307.3531.17.camel@jlt3.sipsolutions.net>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <1292864555-28661-2-git-send-email-lrodriguez@atheros.com> <1293026307.3531.17.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Dec 2010 09:21:21 -0500
Message-ID: <AANLkTimn7K7LG90Q91Sxf-LZpTqbbZL_NeuR7iS5+g3K@mail.gmail.com>
Subject: Re: [PATCH 1/8] wireless-regdb: Add DFS bit fields for countries
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 8:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:
>
>>  for alpha2 in countrynames:
>>      coll = countries[alpha2]
>>      # struct regdb_file_reg_country
>> -    output.write(struct.pack('>ccxxI', str(alpha2[0]), str(alpha2[1]), reg_rules_collections[coll.permissions]))
>> +    output.write(struct.pack('>cchI', str(alpha2[0]), str(alpha2[1]), coll.cflags, reg_rules_collections[coll.permissions]))
>
> maybe you shouldn't be using the full two bytes we have since you just
> need three bits?

Either way is fine, but my thinking here was to just use this as a
general country flag, not just DFS region flag. We can just use one
byte for DFS region and save ourself the last  byte for something else
in the future.

  Luis
