Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:55940 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZAPUi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:38:56 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Fri, 16 Jan 2009 21:38:51 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Artur Skawina <art.08.09@gmail.com>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <496FFC9F.1000907@lwfinger.net> <1232097187.3854.9.camel@johannes>
In-Reply-To: <1232097187.3854.9.camel@johannes>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bBPcJLrwXn7AG/L"
Message-Id: <200901162138.51855.chunkeey@web.de> (sfid-20090116_213901_663983_4C209DBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_bBPcJLrwXn7AG/L
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 16 January 2009 10:13:07 Johannes Berg wrote:
> On Thu, 2009-01-15 at 21:18 -0600, Larry Finger wrote:
> 
> > >>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ikkkkkkkkkkkkkkk
> 
> > I too have seen real single bit changes - in my case 6b went to 6a,
> > and my memory is fine. I wouldn't necessarily blame your hardware.
> 
> 6b to 6a is often the result of a refcounting bug that happens to unref
> a value _after_ it has been freed. But that doesn't explain 6b to 69,
> unless you happen to have _two_ refcounting bugs. Not that I necessarily
> think that memory is bad
Well, this idiotic debug patch (kref-kernel-debug-patch) could shed some light into
the problem who's using a freed skb. 
(and please, I _know_ there is already a better solution for this refcount-thing... but where?)

Of course, there's some sample code to test it... see refcount-test-module.c

BTW, & 0xfffffff0) == 0x6b6b6b60); can detect even more...

Regards,
	Chr

--Boundary-00=_bBPcJLrwXn7AG/L
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="kref-kernel-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kref-kernel-debug.patch"

diff --git a/lib/kref.c b/lib/kref.c
index 9ecd6e8..e143fd8 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -64,6 +64,8 @@ int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 	WARN_ON(release == NULL);
 	WARN_ON(release == (void (*)(struct kref *))kfree);
 
+	WARN_ON((atomic_read(&kref->refcount) & 0xffffffff) == 0x6b6b6b6b);
+
 	if (atomic_dec_and_test(&kref->refcount)) {
 		release(kref);
 		return 1;

--Boundary-00=_bBPcJLrwXn7AG/L
Content-Type: text/x-csrc;
  charset="iso-8859-15";
  name="refcount-test-module.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="refcount-test-module.c"

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kref.h>

static void reftst_release(struct kref *ref)
{
	printk(KERN_INFO "released %p\n", ref);
}

static void reftst_static_simple_test(void)
{
	struct kref test;
	printk(KERN_INFO "RefTest - Static\n");
	kref_init(&test);
	kref_get(&test);
	kref_put(&test, reftst_release);
	kref_put(&test, reftst_release);
}

static void reftst_static_watermark_test(void)
{
	struct kref test;
	printk(KERN_INFO "RefTest - Watermark test\n");
	kref_init(&test);
	kref_set(&test, 0x6b6b6b6b);
	kref_put(&test, reftst_release);
}

struct reftst_struct {
	u8 redzone[32];	/* or just 8 */
	struct kref ref;
	u8 redzone2[32];
};

static void reftst_static_poison_test(void)
{
	struct reftst_struct *test = kzalloc(sizeof(*test), GFP_KERNEL);

	if (!test)
		return;

	printk(KERN_INFO "RefTest - slXb poison test\n");
	kref_init(&test->ref);
	
	kfree(test);

	/* this is illegal, "test" is already freed... so it could oops here */
	kref_put(&test->ref, reftst_release);
}

static int __init reftst_init(void)
{
	printk(KERN_INFO "RefTest\n");
	reftst_static_simple_test();
	reftst_static_watermark_test();
	reftst_static_poison_test();
	
	return 0;
}

static void __exit reftst_exit(void)
{
	
}

module_init(reftst_init);
module_exit(reftst_exit);
MODULE_LICENSE("GPL");

--Boundary-00=_bBPcJLrwXn7AG/L--
