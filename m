Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63809 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaGRRL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 13:11:28 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so3715910oag.14
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 10:11:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1407181339510.15709@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-5-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.11.1407181339510.15709@namei.org>
Date: Fri, 18 Jul 2014 10:05:14 -0700
Message-ID: <CAGXu5jK5np62pR4f7_qa_LU97hBN8e1hu998=C4ah+Xyv3eYtg@mail.gmail.com> (sfid-20140718_191131_498639_C98FA439)
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Morris <james.l.morris@oracle.com>,
	David Howells <dhowells@redhat.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2014 at 8:41 PM, James Morris <jmorris@namei.org> wrote:
> On Mon, 14 Jul 2014, Kees Cook wrote:
>
>> This attaches LSM hooks to the existing firmware loading interfaces:
>> filesystem-found firmware and demand-loaded blobs.
>
>>  static int fw_get_filesystem_firmware(struct device *device,
>> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
>>               break;
>>       case 0:
>>               if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
>> +                     if (security_kernel_fw_from_file(NULL, fw_buf->data,
>> +                                                      fw_buf->size)) {
>> +                             fw_load_abort(fw_priv);
>> +                             break;
>> +                     }
>> +
>>                       set_bit(FW_STATUS_DONE, &fw_buf->status);
>>                       clear_bit(FW_STATUS_LOADING, &fw_buf->status);
>>
>>
>
> Can you explain the loading store, and what the semantics are for an LSM
> when a NULL is passed as the file?

I'm not sure what you mean by "loading store"?

When NULL is passed as the file, it means that the firmware was passes
a blob, and there is no file backing it:

+ * @kernel_fw_from_file:
+ *     Load firmware from userspace.
+ *     @file contains the file structure pointing to the file containing
+ *     the firmware to load. If the module is being loaded from a blob,
+ *     this argument will be NULL.
+ *     @buf pointer to buffer containing firmware contents.
+ *     @size length of the firmware contents.
+ *     Return 0 if permission is granted.

An LSM that has a policy to require a file to back the firmware would
reject such loads.

-Kees

-- 
Kees Cook
Chrome OS Security
