Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50648 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbZI1XFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 19:05:24 -0400
Received: by iwn10 with SMTP id 10so2764741iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 16:05:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254177211.21847.15.camel@mj>
References: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
	<1254177211.21847.15.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Sep 2009 16:05:08 -0700
Message-ID: <43e72e890909281605t679cb207x98819949e27b1f6d@mail.gmail.com>
Subject: Re: Firmware versioning best practices
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 3:33 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2009-09-28 at 15:17 -0700, Luis R. Rodriguez wrote:
>> The ath_hif_usb driver will require the ar9271 firmware file but in
>> the future an open firmware might become available. The ar9170 driver
>> already is under the same situation already: a closed firmware is
>> available but an open firmware can be used, only thing is ar9170 uses
>> the same firmware name for both. We *could* change ar9170 to use the
>> Intel practice of tagging a version at the end of each firmware
>> release, like ar9170-1.fw but ar9170 originally was implemented with a
>> 2-stage firmware requirement and so ar9170-1.fw is already taken.
>
> Versions don't have to start with 1.  We could start e.g. with 10.

Point taken.

>> ar9170 still needs a solution for the different firmwares, once we
>> start supporting the open firmware through some sort of release but
>> I'd like to address ath_hif_usb now early so that we don't run into
>> these snags and use some decent convention that is easy to follow.
>
> We could use ar9170-apiversion-codeverestion.fw and link it to
> ar9170-apiversion.fw.  That is, if the open firmware version is 0.9.0
> and it was compiled for API version 12, the filename would be
> ar9170-12-0.9.0.fw and it could be linked to ar9170-12.fw.

Nice, I like this convention.

>> As I noted above, Intel seems to use the device-1.fw, device-2.fw
>> naming convention. Is this the best approach? Or shall we have the
>> same firmware filename and simply query the firmware for a map of
>> capabilities? Any other ideas?
>
> Distinctive names are good for simplicity of administration and the
> capabilities are good for the sanity of the driver.  But I don't see why
> we cannot have both.

OK sure, thanks for the feedback, at least now I know what naming
scheme to use. The bitmap stuff will have to come later through some
sort of open firmware as I am not sure if we have this with the closed
one.

  Luis
